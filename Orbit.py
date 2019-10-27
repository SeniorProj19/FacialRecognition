#Backend for Senior Project
#from flask import *
from flask import Flask,Blueprint, render_template, request, flash, session, redirect, url_for
from flask import request
import json
import decimal
import datetime
import jsonify

from wtforms import Form, StringField, TextAreaField, PasswordField, validators
from passlib.hash import sha256_crypt
from datetime import datetime
import mysql.connector
import yaml

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
#--------------------------------------------
config = yaml.load(open('config.yaml'))
app = Flask(__name__)
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
    #print('hello')
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

                #makeUserSession(usernameInput)
                #return redirect(url_for(home))
                return redirect(url_for('landing_page'))
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
    return render_template('loginTest.html')

@app.route('/logout') # Not postive if needed - Edwin Pellot
def logout():
    session.pop('username', None)
    session.pop('user_id', None)
    return redirect(url_for('login'))

@app.route('/landing_page')
def landing_page():
    #if 'username' not in session:
    #    return redirect(url_for('login'))
    return render_template('landing_page.html')

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
@app.route('/profile')
def profile():
    try:
        cur = mydb.cursor(dictionary=True)
        if 'username' in session:
            username = session['username']
            statement = "SELECT * FROM information WHERE user_id IN (SELECT user_id FROM login_info WHERE username = '" + username + "')"
            cur.execute(statement)
            result = cur.fetchone()
            resp = jsonify(result)
            resp.status_code = 200
            return resp
    except Exception as e:
        print(e)
    finally:
        return 'not logged in'
        cur.close()
        


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