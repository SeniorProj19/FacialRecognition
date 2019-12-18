#Backend for Senior Project
#----------Import----------
from flask import Flask,Blueprint, render_template, request, flash, session, redirect, url_for, jsonify
from flask import request
import json
import decimal
import datetime
from wtforms import Form, StringField, TextAreaField, PasswordField, validators, FileField, SubmitField
from passlib.hash import sha256_crypt
from datetime import datetime, date
import mysql.connector
import yaml
from wtforms.fields.html5 import DateTimeLocalField, DateTimeField
from flask_uploads import UploadSet, IMAGES, DOCUMENTS 
from flask_wtf import FlaskForm
from flask_wtf.file import FileField, FileAllowed, FileRequired 
import os
import base64
from PIL import Image
from pathlib import Path
from pprint import pprint
from glob import glob
import graphical_utils as gu
import image_loaders as img_ld
import face_collections as fcol
import re
import binascii


#----------Forms--------------------


class RegisterForm(Form):
    username = StringField('Username', [validators.Length(min=1, max=50)])#might be able to add numerous people with the same username need to fix
    password = PasswordField('Password', {
        validators.DataRequired(),
        validators.EqualTo('confirm', message='Passwords do not match')
    })
    confirm = PasswordField('Confirm Password')


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



#--------Connections and Setup-----------------

config = yaml.load(open('config.yaml'))
app = Flask(__name__)
app.secret_key=config['secret_key']


mydb = mysql.connector.connect(
    host=config['host'],
    user=config['user'],
    passwd=config['password'],
    database=config['database']
)
#------------Navigation routes-------------------
@app.route('/')
def home():
    return render_template('homeOrb.html')
   
@app.route('/homeOrb') 
def profPage():
    return render_template('homeOrb.html')



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
def login():
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
                session['username'] = usernameInput
                session['user_id'] = result['user_id']
                statement = "SELECT * FROM information where user_id = '" + str(session['user_id']) + "'"
                cur.execute(statement)
                result = cur.fetchone()
                if result != None: #the user has entered information before
                    return redirect(url_for('profile'))
                else: #first time making information
                    return redirect(url_for('initializeInfo'))
            else:
                error = 'PASSWORD DOESNT MATCH'
                return render_template('loginMerge.html', error=error)

        else:
            error = 'NO USER WITH USERNAME FOUND'
            return render_template('loginMerge.html', error=error)

        cur.close()
        return redirect(url_for('home'))
    return render_template('loginMerge.html')


@app.route('/logout') 
def logout():
    session.pop('username', None)
    session.pop('user_id', None)
    return redirect(url_for('login'))



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
        cur.close()
     
        return redirect(url_for('home'))

    elif request.method == 'GET':
        form.birthday.data = date(9999,12,31)
    
    return render_template('IniMerge.html', form=form)




#-----------Utility Functions--------------
def checkHash(password_candidate, encrypted_password):
    return [True,False][(sha256_crypt.encrypt(password_candidate) == encrypted_password)]
def save_file(form_file, folderName):
    random = binascii.b2a_hex(os.urandom(4))
    _, fileExt = os.path.splitext(form_file.filename)
    newFileName = random + fileExt
    folderName = 'static/' + str(folderName)
    folderName = folderName + '/'
    filePath = os.path.join(app.root_path, folderName, newFileName)
    return filePath

@app.route('/profile', methods=['GET', 'POST']) 
def profile():
    form = InformationForm()
    user_id = session['user_id']
    
    result = getInformation(user_id)
 
    if request.method == 'POST' and form.validate_on_submit():
        cur = mydb.cursor(dictionary=True, buffered=True)
        
        if form.firstName.data != result['first_name']:
            data = [str(form.firstName.data), str(user_id)]
            cur.execute("UPDATE information SET first_name=%s WHERE user_id =%s", data)
        
        if form.lastName.data != result['last_name']:
            data = [str(form.lastName.data), str(user_id)]
            cur.execute("UPDATE information SET last_name=%s WHERE user_id =%s", data)

        if form.phoneNumber.data != result['phone_number']:
            data = [str(form.phoneNumber.data), str(user_id)]
            cur.execute("UPDATE information SET phone_number=%s WHERE user_id =%s", data) 
        
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
            print(data)
            cur.execute("UPDATE information SET profile_pic=%s WHERE user_id =%s", data)
            cur.execute("Insert into photos(photo, user_id) VALUES (%s, %s)", (picture, str(user_id)))
              


        if form.resume.data:
            resume = save_file(form.resume.data, 'resumes')
            form.resume.data.save(resume)
        else:
            resume = ""
        data = [str(resume), str(user_id)]
        cur.execute("UPDATE information SET resume=%s WHERE user_id =%s", data)  
        mydb.commit()
        cur.close()
        return redirect(url_for('home'))

    elif request.method == 'GET':
        form.firstName.data = result['first_name']
        form.lastName.data =  result['last_name']
        form.email.data =  result['email']
        form.jobTitle.data = result['education']
        form.aboutMe.data =  result['about_me']
        form.age.data =  result['age']
        form.birthday.data =  result['birthday']
        form.education.data = result['education']
        form.phoneNumber.data = result['phone_number']
        form.city.data =  result['city']
        form.state.data =  result['state']
        form.zip.data =  result['zip']
        form.currentCompany.data = result['curr_company']

    return render_template('editProfile.html', title='Register', form=form)

#--------Utility Functions------------------------
def getuserIDSession(userName): #only gets called when there is a userName
    cur = mydb.cursor(dictionary=True)
    statement = "SELECT user_id FROM login_info WHERE username = '" + userName + "'"
    cur.execute(statement)
    result = cur.fetchone()
    cur.close()
    return result['user_id']
def getusername(ide): #only gets called when there is a userName
    cur = mydb.cursor(dictionary=True)
    statement = "SELECT username FROM login_info WHERE user_id = '" + str(ide) + "'"
    cur.execute(statement)
    result = cur.fetchone()
    cur.close()
    return result['username']



def searchFaceHelper(userA_id, userB_picturename):
    COLLECT_NAME = 'PicsOfUsers'
    REF_FACE_DIR = 'static/pictures'
    FACE_SEARCH_DIR = 'temp'
    
    if len(fcol.list_collections()) != 0:
      fcol.delete_collection('PicsOfUsers')
    fcol.create_collection(COLLECT_NAME)
    ref_images_dir = Path(REF_FACE_DIR)
    face_file_names = glob(REF_FACE_DIR + '/*.jpg')
    for fileNames in face_file_names:
        fcol.add_face(COLLECT_NAME, fileNames)
        
    faces_info = fcol.find_face(COLLECT_NAME, userB_picturename)
    
    
    print('Found', len(faces_info), 'match' + ('' if len(faces_info) == 1 else 's'))
    matchingFileName = [face_info['Face']['ExternalImageId'] for face_info in faces_info]
    matchingFileName = str(matchingFileName)
    m = re.search(r"\'[^']+\'",matchingFileName)
    if m:
        print(m.group(0))
    else:
        print('Didnt Work')
    
    fileNameWQuotes= str(m.group(0))
    m = re.search(r"[^']+", fileNameWQuotes)
    fileName = str(m.group(0))
    print(fileName)
    folderName = 'static/pictures/'
    filePath = os.path.join(app.root_path, folderName, fileName)
    print(str(filePath))
    data = [str(filePath)]
    cur = mydb.cursor(dictionary=True, buffered=True)
    cur.execute("SELECT user_id FROM photos WHERE photo = %s", data)
    result = cur.fetchone()
    print(result)
    
    userB_id = result['user_id']
    makeRelation(userA_id,userB_id) 
    cur.close()
    
    return userB_id


def makeRelation(userIDA, userIDB):
     cur = mydb.cursor(dictionary=True, buffered=True)
     data= [str(userIDA), str(userIDB)]
     print(data)
     cur.execute("INSERT INTO relations(user_id,paired_user,favorite,time_matched) VALUES(%s, %s, 0, now())", data)
     mydb.commit()
     cur.execute("INSERT INTO relations(paired_user,user_id,favorite,time_matched) VALUES(%s,%s, 0, now())", data)
     mydb.commit()
     cur.close()



def getInformation(user_id):
    cur = mydb.cursor(dictionary=True)
    statement = "SELECT * FROM information WHERE user_id = \'" + str(user_id) +"\'"
    cur.execute(statement)
    result = cur.fetchone()
    cur.close()
    return result

    
    
#--------------------Mobile Routes ------------------
@app.route('/mlogin', methods=['POST','GET'])
def mLogin(): #unlimted login attempts - limit ammount of tries
        usernameInput = request.form['username']
        password_candidate = request.form['password']
        
        cur = mydb.cursor(dictionary=True)
        statement = "SELECT * FROM login_info WHERE username = '" + usernameInput + "'"
        cur.execute(statement)
        result = cur.fetchone()
        if result != None:
            password = str(result['password'])
            if sha256_crypt.verify(password_candidate, password):
                #session['logged_in'] = True
                
                session['username'] = usernameInput
                session['user_id'] = getuserIDSession(usernameInput)

                msg = {"status" : { "type" : "success" ,
                             "message" : "You logged in"} , 
               "data" : {"user" : session['username'],
                                "user_id": session['user_id'] }}
                print(msg)
                return jsonify(msg)
            else:
                msg = {"status" : { "type" : "failure" ,   "message" : "Username or password incorrect"}}
                print(msg)
                return jsonify(msg)
        else:
            msg = {"status" : { "type" : "failure" ,   "message" : "Missing Data"}}
        print(msg)
        return jsonify(msg)
        cur.close()

@app.route('/profileinfo')
def profileinfo():
        cur = mydb.cursor(dictionary=True)
        if 'username' in session:
            user_id = getuserIDSession(session['username'])
            statement = "SELECT * FROM information WHERE user_id = '"+str(user_id)+"'"
            cur.execute(statement)
            result = cur.fetchone()
            result.update(birthday = str(result['birthday']))
            with open(result['profile_pic'], "rb") as imageFile:
                byte = str(base64.b64encode(imageFile.read()))
            result.update(profile_pic = byte)
            jsonCon = json.dumps(result)
            print(jsonCon)
            return jsonCon
        return 'not logged in'
        cur.close()
@app.route('/<int:user_id>')
def getUser(user_id):
            cur = mydb.cursor(dictionary=True)
            statement = "SELECT * FROM information WHERE user_id = '"+str(user_id)+"'"
            cur.execute(statement)
            result = cur.fetchone()
            result.update(birthday = str(result['birthday']))
            with open(result['profile_pic'], "rb") as imageFile:
                byte = str(base64.b64encode(imageFile.read()))
            result.update(profile_pic = byte)
            jsonCon = json.dumps(result)
            print(jsonCon)
            return jsonCon
            
@app.route ('/connections')
def connections():
     cur = mydb.cursor(dictionary=True)
     if 'username' in session:
            user_id = getuserIDSession(session['username'])

            statement = "Select i.user_id, i.first_name, i.last_name, i.profile_pic, i.email, i.job_title, i.about_me, i.age, i.birthday, i.phone_number, i.resume, i.education, i.city, i.state, i.zip, i.curr_company from information i right join (Select paired_user, time_matched from relations where user_id = " + str(user_id)+ ") r on i.user_id = r.paired_user order by r.time_matched desc"
            cur.execute(statement)
            result = cur.fetchall()
            for ppl in result:
                ppl.update(birthday = str(ppl['birthday']))
                with open(ppl['profile_pic'], "rb") as imageFile:
                    byte = str(base64.b64encode(imageFile.read()))
                ppl.update(profile_pic = byte)
            jsonCon = json.dumps(result)
            print(jsonCon)
            return jsonCon
            
@app.route ('/connections/<int:user_id>')
def getConnections(user_id):
     cur = mydb.cursor(dictionary=True)
     statement = "Select i.user_id, i.first_name, i.last_name, i.profile_pic, i.email, i.job_title, i.about_me, i.age, i.birthday, i.phone_number, i.resume, i.education, i.city, i.state, i.zip, i.curr_company from information i right join (Select paired_user, time_matched from relations where user_id = " + str(user_id)+ ") r on i.user_id = r.paired_user order by r.time_matched desc"
     cur.execute(statement)
     result = cur.fetchall()
     for ppl in result:
        ppl.update(birthday = str(ppl['birthday']))
        with open(ppl['profile_pic'], "rb") as imageFile:
             byte = str(base64.b64encode(imageFile.read())) 
        ppl.update(profile_pic = byte)
     jsonCon = json.dumps(result)
     print(jsonCon)
     return jsonCon

     
@app.route ('/photocomparsion/<int:user_id>', methods=['POST','GET'])
def comp(user_id):
    name = request.form['name']
    img = request.form['image']
    buffer_ob = buffer(img)
    encode = img.encode()
    imgFile = base64.b64decode(encode)
    complete_path = os.path.join('_temp/', name) 
    image_result = open(complete_path, 'wb')
    done = image_result.write(imgFile)
    image_result.close
    print(complete_path)
    try:
        match = searchFaceHelper(user_id, complete_path)
    except:
        msg = {'match':'None'}
        return jsonify(msg)
    print(match)
    match_username = getusername(match)
    msg = {'match':match_username}
    return jsonify(msg)


    
if __name__ == '__main__':
    
    app.run(host='0.0.0.0',port = 8080)
