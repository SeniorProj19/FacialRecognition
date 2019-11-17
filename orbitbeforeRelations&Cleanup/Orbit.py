#Backend for Senior Project
#from flask import *
import sys
from flask import Flask,Blueprint, render_template, request, flash, session, redirect, url_for
from flask import request
import json
import decimal
import datetime
from datetime import date
from wtforms import Form, StringField, TextAreaField, PasswordField, validators, FileField, SubmitField
from passlib.hash import sha256_crypt
import mysql.connector
from wtforms.fields.html5 import DateTimeLocalField, DateTimeField
import uuid
import base64
from flask_uploads import UploadSet, IMAGES, DOCUMENTS 
from flask_wtf import FlaskForm
from flask_wtf.file import FileField, FileAllowed, FileRequired 
import os
import secrets
import yaml
from PIL import Image


#----------Forms--------------------


class RegisterForm(Form):
    username = StringField('Username', [validators.Length(min=1, max=50)])#might be able to add numerous people with the same username need to fix
    password = PasswordField('Password', {
        validators.DataRequired(),
        validators.EqualTo('confirm', message='Passwords do not match')
    })
    confirm = PasswordField('Confirm Password')

    #def validate_username(self, username):
        #cur = mydb.cursor(dictionary=True)
        #statement = "SELECT * FROM login_info WHERE username = '" + username.data + "'"
        #cur.execute(statement)
        #result = cur.fetchone()

        #if result != None:
           #print('That username is taken. Please choose another Username')



class LoginForm(Form):
    username = StringField('Username', validators.DataRequired())
    password = PasswordField('Password', validators.DataRequired())


files = UploadSet('files', ['doc', 'pdf', 'txt'])
photos = UploadSet('photos', IMAGES)
WTF_CSRF_SECRET_KEY = 'a random string'
class InitializeForm(FlaskForm):
    firstName = StringField('First Name', [validators.Length(max=45)])
    lastName = StringField('Last Name', [validators.Length(max=45)])
    profilePicture = FileField('Picture', validators=[FileRequired(),
        FileAllowed(IMAGES, 'Invalid Photo Type')])
    resume = FileField('Resume', validators=[
        FileAllowed(['doc','docx', 'pdf', 'txt'], 'Documents only!')
    ])


    email = StringField('Email', [validators.Length(max=100)])
    education = StringField('Education', [validators.Length(max=45)])
    jobTitle = StringField('Job Title', [validators.Length(max=45)])
    currentCompany = StringField('Current Company', [validators.Length(max=45)])
    birthday = DateTimeField('Birthday', format='%m/%d/%y') 
    phoneNumber = StringField('Phone Number', [validators.Length(max=15)])
    age = StringField('Age', [validators.Length(max=4)]) 
    city = StringField('Home Town', [validators.Length(max=45)])
    state = StringField('State', [validators.Length(max=45)])
    zip = StringField('Zip', [validators.Length(max=45)])
    aboutMe = TextAreaField('About Me', [validators.Length(max=500)])

    submit = SubmitField('Upload')  


class InformationForm(FlaskForm):
    firstName = StringField('First Name', [validators.Length(max=45)])
    lastName = StringField('Last Name', [validators.Length(max=45)])
    profilePicture = FileField('Picture', validators=[FileRequired(),
        FileAllowed(IMAGES, 'Invalid Photo Type')])
    resume = FileField('Resume', validators=[
        FileAllowed(['doc','docx', 'pdf', 'txt'], 'Documents only!')
    ])
    email = StringField('Email', [validators.Length(max=100)])
    education = StringField('Education', [validators.Length(max=45)])
    jobTitle = StringField('Job Title', [validators.Length(max=45)])
    currentCompany = StringField('Current Company', [validators.Length(max=45)])
    birthday = DateTimeField('Birthday', format='%m/%d/%y') 
    phoneNumber = StringField('Phone Number', [validators.Length(max=15)])
    age = StringField('Age', [validators.Length(max=4)]) 
    city = StringField('Home Town', [validators.Length(max=45)])
    state = StringField('State', [validators.Length(max=45)])
    zip = StringField('Zip', [validators.Length(max=45)])
    aboutMe = TextAreaField('About Me', [validators.Length(max=500)])

    submit = SubmitField('Upload')  
    #def validate_username(self, username):
    #    if username.data != session['username']:
    #        cur = mydb.cursor(dictionary=True)
    #        statement = "SELECT * FROM login_info WHERE username = '" + username.data + "'"
    #        cur.execute(statement)
    #        result = cur.fetchone()
    #        if result != None:
    #           #raise ValidationError ('That username is taken. Please choose another Username')
    #          print('That username is taken. Please choose another Username')
#--------Connections and Setup-----------------

app = Flask(__name__)
config = yaml.load(open('config.yaml'))
app.secret_key=config['secret_key']

mydb = mysql.connector.connect(
    host= config['host'],
    user= config['user'],
    passwd= config['password'],
    database= config['database']
)
#------------Navigation routes-------------------
@app.route('/')
def home():
    return render_template('home.html')

@app.route('/about')
def about():
    return render_template('about.html')
   
@app.route('/homeOrb') 
def profPage():
    return render_template('homeOrb.html')

@app.route('/profLogin')
def profLoginPage():
    return render_template('Login.html')

@app.route('/profRegister')
def profRegisterPage():
    return render_template('Register.html')

@app.route('/register', methods=['GET', 'POST'])
def register():
    form = RegisterForm(request.form)
    print(str(form.username.data))
    if request.method == 'POST' and form.validate():
         username = form.username.data
         password = sha256_crypt.encrypt(form.password.data)

         cur = mydb.cursor()
         cur.execute("INSERT INTO login_info(username, password) VALUES (%s, %s) ", (username, password))
         mydb.commit()
         cur.close()
         return redirect(url_for('home'))
    return render_template('registerMerge.html',form=form)

@app.route('/login', methods=['GET', 'POST'])
def login(): #unlimted login attempts - limit ammount of tries
    if request.method == 'POST':
        usernameInput = request.form['username']
        password_candidate = request.form['password']
        
        cur = mydb.cursor(dictionary=True, buffered=True)
        statement = "SELECT * FROM login_info WHERE username = '" + usernameInput + "'"
        cur.execute(statement)
        result = cur.fetchone()
        
        if result != None:
            password = str(result['password'])
            if sha256_crypt.verify(password_candidate, password):
                #session['logged_in'] = True
                
                session['username'] = usernameInput
                session['user_id'] = result['user_id']

                #makeUserSession(usernameInput)
                #return redirect(url_for(home))
                statement = "SELECT * FROM information where user_id = '" + str(session['user_id']) + "'"
                cur.execute(statement)
                result = cur.fetchone()
                if result != None: #the user has entered information before
                    return redirect(url_for('profile'))
                else: #first time making information
                    return redirect(url_for('initializeInfo'))
            else:
                error = 'PASSWORD DOESNT MATCH'
                return render_template('loginTest.html', error=error)
                #return render_template('loginTest.html')
        else:
            error = 'NO USER WITH USERNAME FOUND'
            return render_template('loginTest.html', error=error)
            #return render_template('loginTest.html')
        cur.close()
        return redirect(url_for('home'))
    return render_template('loginMerge.html')

@app.route('/landing_page')
def landing_page():
    #if 'username' not in session:
    #    return redirect(url_for('login'))
    return render_template('landing_page.html')


@app.route('/initialize', methods=['GET', 'POST'])
def initializeInfo():
    form = InitializeForm()

    if request.method == 'POST' and form.validate_on_submit():
        firstName = form.firstName.data
        lastName = form.lastName.data
        
        if form.profilePicture.data:
            picture = save_file(form.profilePicture.data, 'pictures')
            i = Image.open(form.profilePicture.data)
            i.save(picture)
            print(picture)
            

        if form.resume.data:
            resume = save_file(form.resume.data, 'resumes')
            form.resume.data.save(resume)
        else:
            resume=""

        phoneNumber = form.phoneNumber.data
        email  = form.email.data
        jobTitle = form.jobTitle.data
        aboutMe = form.aboutMe.data
        if form.age.data:
            age = form.age.data
        else:
            age = 0
        birthday = form.birthday.data
        education = form.education.data
        city = form.city.data
        state = form.state.data
        zip = form.zip.data
        
        currentCompany = form.currentCompany.data
        user_id = session['user_id']

        cur = mydb.cursor(dictionary=True)
        statement = ("Insert into information(user_id, first_name, last_name, profile_pic, email, job_title, about_me, age, birthday, phone_number, resume, education, city, state, zip, curr_company)"
                    "VALUES(%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s ,%s)")
        data = [str(user_id), str(firstName), str(lastName), picture, str(email), str(jobTitle), str(aboutMe), str(age), str(birthday), str(phoneNumber), str(resume), str(education), str(city), str(state),str(zip), str(currentCompany)]       
        cur.execute(statement, data)
        cur.execute("Insert into photos(photo, user_id) VALUES (%s, %s)", (picture, str(user_id)))
        mydb.commit()
        #result = cur.fetchone()
        cur.close()
     
        return redirect(url_for('home'))

    elif request.method == 'GET':
        form.birthday.data = date(9999,12,31)
    
    return render_template('initialize.html', form=form)


def save_file(form_file, folderName):
     random = secrets.token_hex(8)
     fileName, fileExt = os.path.splitext(form_file.filename)
     newFileName = random + fileExt
     folderName = 'static/' + str(folderName)
     filePath = os.path.join(app.root_path, folderName, newFileName)
     return filePath

@app.route('/profile', methods=['GET', 'POST']) 
def profile():
    form = InformationForm()
    user_id = session['user_id']
    
    result = getInformation(user_id)
 
    if request.method == 'POST' and form.validate_on_submit():
        cur = mydb.cursor(dictionary=True, buffered=True)
        #statement = "UPDATE information SET %s=%s WHERE user_id =\'" + str(user_id) +"\'"
        #statement = "UPDATE information SET %s=%s WHERE user_id =\'" + str(user_id) +"\'"
        if form.firstName.data != result['first_name']:
            data = [str(form.firstName.data), str(user_id)]
            cur.execute("UPDATE information SET first_name=%s WHERE user_id =%s", data)
        
        if form.lastName.data != result['last_name']:
            data = [str(form.lastName.data), str(user_id)]
            cur.execute("UPDATE information SET last_name=%s WHERE user_id =%s", data)

        #if form.picture.data != result['profile_pic']:
            #cur.execute(statement, ['profile_pic', str(form.firstName.data)])

        if form.phoneNumber.data != result['phone_number']:
            data = [str(form.phoneNumber.data), str(user_id)]
            cur.execute("UPDATE information SET phone_number=%s WHERE user_id =%s", data) 
            #cur.execute("UPDATE information SET phone_number='%s' WHERE user_id = '1'", (str(form.phoneNumber.data)) )
        
        if form.email.data != result['email']:
            data = [str(form.email.data), str(user_id)]
            cur.execute("UPDATE information SET email=%s WHERE user_id =%s", data) 

            
        if form.jobTitle.data != result['job_title']:
            data = [str(form.jobTitle.data), str(user_id)]
            cur.execute("UPDATE information SET job_title=%s WHERE user_id =%s", data) 
        
        if form.aboutMe.data != result['about_me']:
            data = [str(form.aboutMe.data), str(user_id)]
            cur.execute("UPDATE information SET about_me=%s WHERE user_id =%s", data)

        if form.age.data != result['age']:
            if form.age.data:
                age = form.age.data
            else:
                age = 0
            data = [str(age), str(user_id)]
            cur.execute("UPDATE information SET age=%s WHERE user_id =%s", data) 
        
        if form.birthday.data != result['birthday']:
            data = [str(form.birthday.data), str(user_id)]
            cur.execute("UPDATE information SET birthday=%s WHERE user_id =%s", data)
        if form.education.data != result['education']:
            data = [str(form.education.data), str(user_id)]
            cur.execute("UPDATE information SET education=%s WHERE user_id =%s", data)
        if form.city.data != result['city']:
            data = [str(form.city.data), str(user_id)]
            cur.execute("UPDATE information SET city=%s WHERE user_id =%s", data)

        if form.state.data != result['state']:
            data = [str(form.state.data), str(user_id)]
            cur.execute("UPDATE information SET state=%s WHERE user_id =%s", data)
        if form.zip.data != result['zip']:
            data = [str(form.zip.data), str(user_id)]
            cur.execute("UPDATE information SET zip=%s WHERE user_id =%s", data)
        if form.currentCompany.data != result['curr_company']:
            data = [str(form.currentCompany.data), str(user_id)]
            cur.execute("UPDATE information SET curr_company=%s WHERE user_id =%s", data)

        if form.profilePicture.data:
            picture = save_file(form.profilePicture.data, 'pictures')
            i = Image.open(form.profilePicture.data)
            i.save(picture)
            data = [picture, str(user_id)]
            cur.execute("UPDATE information SET profile_pic=%s WHERE user_id =%s", data)
            cur.execute("Insert into photos(photo, user_id) VALUES (%s, %s)", (picture, str(user_id)))
              


        if form.resume.data:
            resume = save_file(form.resume.data, 'resumes')
            form.resume.data.save(resume)
        else:
            resume = ""
        data = [str(resume), str(user_id)]
        cur.execute("UPDATE information SET resume=%s WHERE user_id =%s", data)  


        #cur = mydb.cursor(dictionary=True)
        #statement = ("Insert into information(user_id, first_name, last_name, profile_pic, email, job_title, about_me, age, birthday, phone_number, resume, education, city, state, zip, curr_company)"
        # "VALUES(%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)")
        #data = [str(user_id), str(firstName), str(lastName), str(picture), str(email), str(jobTitle), str(aboutMe), str(age), str(birthday), str(phoneNumber), str(resume), str(education), str(city), str(state),str(zip), str(currentCompany)]       
        #cur.execute(statement, data)
        mydb.commit()
        #result = cur.fetchone()
        cur.close()
        return redirect(url_for('landing_page'))

    elif request.method == 'GET':
        #form.username.data = current_user.username
        #form.email.data = current_user.email
        #picture_path = result['profile_pic']
        form.firstName.data = result['first_name']
        form.lastName.data =  result['last_name']
        #form.profilePicture.data
        form.email.data =  result['email']
        form.jobTitle.data =  result['education']
        form.aboutMe.data =  result['about_me']
        form.age.data =  result['age']
    
        #form.birthday.data = '02/26/1998'
        form.birthday.data =  result['birthday']
        #form.resume.data =
        form.education.data = result['education']
        form.phoneNumber.data = result['phone_number']
        form.city.data = 'Sewell'
        form.state.data = 'NJ'
        form.zip.data = '08028'

        #---hardcoded test data
        #form.firstName.data = 'Shafin'
        #form.lastName.data =  'Siraj'
        ##form.profilePicture.data
        #form.email.data = 'ssiraj1998'
        #form.jobTitle.data = 'Student'
        #form.aboutMe.data = 'Im a student'
        #form.age.data = '21'
    
        ##form.birthday.data = '02/26/1998'
        #form.birthday.data = date(1998,2,26)
        ##form.resume.data =
        #form.education.data = 'Student'
        #form.city.data = 'Sewell'
        #form.state.data = 'NJ'
        #form.zip.data = '08028'

    

    #image_file = url_for('static', filename='profile_pics/' + current_user.image_file)
    #return render_template('account.html', title='Account', image_file=image_file, form=form)
    return render_template('accountInfo.html', title='Register', form=form)
    #return render_template('profile.html')



def getInformation(user_id):
    cur = mydb.cursor(dictionary=True)
    statement = "SELECT * FROM information WHERE user_id = \'" + str(user_id) +"\'"
    cur.execute(statement)
    result = cur.fetchone()
    cur.close()
    return result


@app.route('/edit')
def edit():
    return render_template('edit.html')


#--------Utility Functions------------------------
def getuserIDSession(userName): #only gets called when there is a userName
    cur = mydb.cursor(dictionary=True)
    statement = "SELECT user_id FROM login_info WHERE username = '" + userName + "'"
    cur.execute(statement)
    result = cur.fetchone()
    cur.close()
    return result['user_id']



#--------Return Functions------------------------
@app.route('/format')
def orb():
    return render_template('homeOrb.html')

@app.route('/makesession')
def makesession():
    session['username'] = 'Anthony'
    return 'index'

@app.route('/getsession')
def getsession():
    if 'username' in session:
        return session['username']
    return 'not logged in'


def checkHash(password_candidate, encrypted_password):
    return [True,False][(sha256_crypt.encrypt(password_candidate) == encrypted_password)]


@app.route('/check')
def selectAll():
    username = 's'
    statement = "SELECT * FROM login_info WHERE username = '" + username + "'"
    print(str(statement))
    cur = mydb.cursor()
    cur.execute("Select * FROM login_info WHERE username= 's'")
    myresult = cur.fetchall()
    return str(myresult)



@app.route('/math')
def calc():
    #cur = mysql.connection.cursor()
    #cur.execute('''CREATE TABLE example (id INTEGER, name VARCHAR(20))''')
    
    #cur.execute('''INSERT INTO example VALUES (1, 'hi')''')
    #cur.execute('''INSERT INTO example VALUES (2, 'how are you')''')
    #mysql.connection.commit()
    #cur.execute('''Select * FROM login_info''')
    #rv = cur.fetchall()
    #return rv[0]['name']


    #cur = mydb.cursor()
    #cur.execute("Select * FROM login_info")
    #myresult = cur.fetchall()
    #return myresult
    return 'calculation page'

@app.route('/testuser')
def createDatabase():
    #cur = mysql.connection.cursor()
    #cur.execute('''SELECT * FROM login_info ''')
    #rv = cur.fetchall()
    #cur.execute("INSERT INTO login_info(username, pasword) VALUES (%s, %s) ", ('hello', 'testing123'))
    #return str(rv)
    return 'testuser'

    
if __name__ == '__main__':
    
      app.run(host = '0.0.0.0',port = 8080)