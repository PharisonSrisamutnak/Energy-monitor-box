import datetime
import mysql.connector as mysql
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
import json
from fastapi import FastAPI

import requests, json
import urllib.parse
import sys

from quickchart import QuickChart

URL_LINE = "https://notify-api.line.me/api/notify" 

app = FastAPI()
#conect to MySQL database
#####################################connect MySQL#####################################
db = mysql.connect(
    host = "localhost",
    user = "********", #replace ******** with user mysql
    passwd = "********", #replace ******** with pass mysql
    database = "********" #replace ******** with database name
)
#####################################connect MySQL#####################################

cursor = db.cursor()


app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

feb28 = [31,28,31,30,31,30,31,31,30,31,30,31]
feb29 = [31,29,31,30,31,30,31,31,30,31,30,31]


@app.get("/History/{ID_Device}/{DS}/{DE}") #get path connect to api
def read_History(ID_Device,DS,DE): #read vales form api path    
    query = """SELECT ID_Device ,Sensor1 ,Sensor2 ,Sensor3 ,Date FROM Log WHERE ID_Device Like %s AND Date BETWEEN %s AND %s"""
    cursor.execute(query,(ID_Device,DS,DE,))        
    row_headers=[x[0] for x in cursor.description] #create list for row_headers json
    records = cursor.fetchall() ## fetching all records from the 'cursor' object
    db.commit()
    json_data=[] #creat list for json
    list_date = [] #creat list
    for x in range((len(records)-1),-1,-1):
    	#print(str(x))
        if x == 0:
            list_date.append(str(records[x][4]))
        elif str(records[x-1][4]) != str(records[x][4]):
            list_date.append(str(records[x][4]))
    #print(str(records))
    result = [[] for j in range(len(list_date))] #creat list 2 dimension
    total_Sensor1 = 0.0
    total_Sensor2 = 0.0
    total_Sensor3 = 0.0
    list_date_count = 0
    #print(str(list_date_count)) 
    for x in range((len(records)-1),-1,-1):
        #print(str(x))
        if str(list_date[list_date_count]) == str(records[x][4]):            
            total_Sensor1 +=  records[x][1]
            total_Sensor2 +=  records[x][2]
            total_Sensor3 +=  records[x][3]
            #print("date==" + " " + "total_Sensor1 : " + str(records[x][1]) + " " + "total_Sensor2 : " + str(records[x][1]) + " " + "total_Sensor3 : " + str(records[x][1]))
        else:
            #print("date!=")
            result[list_date_count].append(str(records[x][0]))
            result[list_date_count].append(str(total_Sensor1))
            result[list_date_count].append(str(total_Sensor2))
            result[list_date_count].append(str(total_Sensor3))
            result[list_date_count].append(str(list_date[list_date_count]))
            total_Sensor1 = 0.0
            total_Sensor2 = 0.0
            total_Sensor3 = 0.0
            total_Sensor1 +=  records[x][1]
            total_Sensor2 +=  records[x][2]
            total_Sensor3 +=  records[x][3]
        if x == 0:
            #print("X == 0" + " " + "total_Sensor1 : " + str(total_Sensor1) + " " + "total_Sensor2 : " + str(total_Sensor2) + " " + "total_Sensor3 : " + str(total_Sensor3))
            result[list_date_count].append(str(records[x][0]))
            result[list_date_count].append(str(total_Sensor1))
            result[list_date_count].append(str(total_Sensor2))
            result[list_date_count].append(str(total_Sensor3))
            result[list_date_count].append(str(list_date[list_date_count]))
            total_Sensor1 = 0.0
            total_Sensor2 = 0.0
            total_Sensor3 = 0.0
        if str(list_date[list_date_count]) != str(records[x][4]):
            list_date_count += 1
    for jsonStr in result:
        json_data.append(dict(zip(row_headers,jsonStr))) #add json header
    return json_data #return json
###############################################################################
@app.get("/Register/{user}/{passwd}") #get path connect to api
def read_Register(user,passwd): #read vales form api path
    regQuery = "SELECT Name_User FROM Users WHERE Name_User Like %s " ## SELECT records from the table
    cursor.execute(regQuery,(user,))
    regQueryresult = cursor.fetchall() ## fetching all records from the 'cursor' object
    db.commit()
    #if user not match insert user and password to Users table
    if len(regQueryresult) == 0:
            values = (user,passwd)
            insert_User = "INSERT INTO Users (Name_User, Password) VALUES (%s, %s)"
            cursor.execute(insert_User, values) #insert user and password into database
            db.commit()
            idUser_Query = "SELECT ID_User FROM Users WHERE Name_User Like %s "
            cursor.execute(idUser_Query, (user,)) #ID_User form database
            idUser_QueryQueryresult = cursor.fetchall()
            db.commit()
            noti_values = (0,"null",str(idUser_QueryQueryresult[0][0]))
            insert_Noti = "INSERT INTO Nontification (Status, line_noti_Token, ID_User) VALUES (%s, %s, %s)"
            cursor.execute(insert_Noti, noti_values) #insert noti setting to database
            db.commit()
            return True #return to client
    else:
    	return False #return to client
###############################################################################
@app.get("/Login/{user}/{passwd}") #get path connect to api
def read_Login(user,passwd): #read vales form api path
    loginQuery = "SELECT Name_User, Password, ID_User FROM Users WHERE Name_User Like %s " #command for select data in table
    cursor.execute(loginQuery,(user,))
    loginQueryresult = cursor.fetchall()
    db.commit()
    if len(loginQueryresult) != 0: #check user
    	if str(loginQueryresult[0][0]) == str(user) and str(loginQueryresult[0][1]) == str(passwd): #check user and password
    		return loginQueryresult[0][2] #return ID_User
    	else:
            return "user or password wrong" #return "user or password wrong"
    else:
        return "not register" #return "not register"
###############################################################################
@app.get("/addDevice/{ID_Device}/{ID_User}") #get path connect to api
def read_addDevice(ID_Device,ID_User): #read vales form api path
    addDeviceQuery = "SELECT ID_Device FROM Device WHERE ID_Device Like %s" # SELECT records from the table
    cursor.execute(addDeviceQuery,(ID_Device,)) # fetching all records from the 'cursor' object
    addDeviceQueryresult = cursor.fetchall()
    db.commit()
    userDeviceQuery = "SELECT ID_Device FROM Users_Device WHERE ID_Device Like %s AND ID_User Like %s" # SELECT records from the table
    cursor.execute(userDeviceQuery,(ID_Device,ID_User)) # fetching all records from the 'cursor' object
    userDeviceQueryresult = cursor.fetchall()
    db.commit()
    userDevicetotalsQuery = "SELECT ID_Device FROM Users_Device WHERE ID_User Like %s" # SELECT records from the table
    cursor.execute(userDevicetotalsQuery,(ID_User,)) # fetching all records from the 'cursor' object
    userDevicetotalsresult = cursor.fetchall()
    db.commit()
    #check ID_Device form table Compare ID_Device form api
    if len(addDeviceQueryresult) != 0 and str(addDeviceQueryresult[0][0]) == str(ID_Device) and len(userDeviceQueryresult) == 0 and len(userDevicetotalsresult) < 8: 
        values = (ID_Device,ID_User)
        insert_User_Device = "INSERT INTO Users_Device (ID_Device, ID_User) VALUES (%s, %s) "
        cursor.execute(insert_User_Device, values)
        db.commit()
        #print(True)
        return True #check Device if correct return true
    else:
    	print(False)
    	return False #check Device if wrong return false
#################################################################################
@app.get("/deleteDevice/{ID_Device}/{ID_User}")#get path connect to api
def read_deleteDevice(ID_Device,ID_User):#read vales form api path
    userDeviceQuery = "SELECT ID_Users_Device FROM Users_Device WHERE ID_Device Like %s AND ID_User Like %s" # SELECT records from the table
    cursor.execute(userDeviceQuery,(ID_Device,ID_User))  # fetching all records from the 'cursor' object
    userDeviceQueryresult = cursor.fetchall()
    db.commit()
    if len(userDeviceQueryresult) != 0: #check userDevice form table for delete
        delete_User_Device = "DELETE FROM Users_Device WHERE ID_Device Like %s AND ID_User Like %s" # DELETE records from the table
        cursor.execute(delete_User_Device,(ID_Device,ID_User))  #fetching all records from the 'cursor' object
        db.commit()
        return True #return true if delete complete
    else:
    	return False #return false if delete not complete

#################################################################################
@app.get("/userDevice/{ID_User}")#get path connect to api
def read_addDevice(ID_User):#read vales form api path
        userDeviceQuery = "SELECT ID_Device FROM Users_Device WHERE ID_User Like %s " # SELECT records from the table
        cursor.execute(userDeviceQuery,(ID_User,)) #fetching all records from the 'cursor' object
        row_headers=[x[0] for x in cursor.description] #create list for json header
        userDeviceQueryresult = cursor.fetchall() #fetching all records from the 'cursor' object
        db.commit()
        json_userDevice=[] #create list for userDevice
        if len(userDeviceQueryresult) != 0:
            for jsonStr in userDeviceQueryresult:
                json_userDevice.append(dict(zip(row_headers,jsonStr))) #add json header
            return json_userDevice #return json
        else:
            return False #return false
#################################################################################
@app.get("/settingNoti/{ID_User}/{noti_Status}") #get path connect to api
def read_settingNoti(ID_User,noti_Status): #read vales form api path
    notiQuery = "SELECT ID_User FROM Nontification WHERE ID_User Like %s " # SELECT records from the Nontification table
    cursor.execute(notiQuery,(ID_User,)) #fetching all records from the 'cursor' object
    notiQueryresult = cursor.fetchall()
    db.commit()
    if(len(notiQueryresult) != 0 and str(notiQueryresult[0][0]) == ID_User): #check ID_User for update  noti status
        updateSetting = "UPDATE Nontification SET Status = %s WHERE ID_User = %s" # UPDATE Status from the Nontification table
        val = (int(noti_Status), ID_User)
        cursor.execute(updateSetting,val)
        db.commit()
        return noti_Status #return noti_Status
    else:
        return False #return false
#################################################################################
@app.get("/addnotiToken/{ID_User}/{noti_token}") #get path connect to api
def read_addnotiToken(ID_User,noti_token): #read vales form api path
    notiQuery = "SELECT ID_User FROM Nontification WHERE ID_User Like %s " # SELECT ID_User from the Nontification table
    cursor.execute(notiQuery,(ID_User,)) #fetching all records from the 'cursor' object
    notiQueryresult = cursor.fetchall()
    db.commit()
    status = line_text("เพิ่ม Token สำเร็จ",noti_token) #call function send message to Application Line
    if(len(notiQueryresult) != 0 and str(notiQueryresult[0][0]) == ID_User and int(status) == 200): #check ID_User and check Line noti_token
        update_notiToken = "UPDATE Nontification SET Status = 1, line_noti_Token = %s WHERE ID_User = %s" # UPDATE line_noti_Token from the Nontification table
        val = (noti_token, ID_User)
        cursor.execute(update_notiToken,val) #execute command 
        db.commit()
        return True #return true if ID_User and Line noti_token correct
    else:
        return False #return false if ID_User and Line noti_token wrong
#################################################################################
@app.get("/deletenotiToken/{ID_User}") #get path connect to api
def read_deletenotiToken(ID_User): #read vales form api path
    notiQuery = "SELECT ID_User FROM Nontification WHERE ID_User Like %s " # SELECT ID_User from the Nontification table
    cursor.execute(notiQuery,(ID_User,)) #execute command fetching all records from the 'cursor' object
    notiQueryresult = cursor.fetchall()
    db.commit()
    if(len(notiQueryresult) != 0 and str(notiQueryresult[0][0]) == ID_User): #check ID_User
        update_notiToken = """UPDATE Nontification SET Status = 0, line_noti_Token = "null" WHERE ID_User = %s""" # UPDATE Status and line_noti_Token from the Nontification table
        val = (ID_User,)
        cursor.execute(update_notiToken,val) #execute command for update
        db.commit()
        return True #return true
    else:
        return False #return false
#################################################################################
@app.get("/getsettingnotiToken/{ID_User}") #get path connect to api
def read_deletenotiToken(ID_User): #read vales form api path
    notiQuery = "SELECT Status, line_noti_Token, ID_User FROM Nontification WHERE ID_User Like %s " # SELECT ID_User from the Nontification table
    cursor.execute(notiQuery,(ID_User,)) #execute command fetching all records from the 'cursor' object
    notiQueryresult = cursor.fetchall()
    db.commit()
    if(len(notiQueryresult) != 0 and str(notiQueryresult[0][2]) == ID_User): #check ID_User
    	if str(notiQueryresult[0][1]) == "null":
    		print("API getsettingnotiToken is True")
    		val = ["True",notiQueryresult[0][0],str(notiQueryresult[0][1])]
    		return val #return true
    	else:
            print("API getsettingnotiToken is False")
            token = str(notiQueryresult[0][1])
            val = ["True",notiQueryresult[0][0],token[len(token)-5:len(token)]]
            return val #return true	
    else:
        return False #return false
#################################################################################
@app.get("/chart/{ID_Device}/{Date}") #get path connect to api
def read_chart(ID_Device,Date): #read vales form api path
    query = "SELECT Sensor1 ,Sensor2 ,Sensor3 ,Time FROM Log WHERE ID_Device Like %s AND Date = %s" #query sensor value for calculate total unit command for select in mySqpl database
    cursor.execute(query,(ID_Device,Date))
    checkQueryresult = cursor.fetchall()
    db.commit()    
    
    #print(Queryresult[0][3])
    if(len(checkQueryresult) != 0): #check ID_Device and Date form table
        sensor1 = [] #create list
        sensor2 = [] #create list
        sensor3 = [] #create list
        timechart = [] #create list
        #print(week + " Queryresult : " + str(Queryresult) + " Length : " + str(len(Queryresult)))                                      
        for k in range(0,24):          
            x = datetime.datetime.now()        
            ts = x.strftime(str(k)+":00:00") #create time format
            te = x.strftime(str(k)+":59:59") #create time format
            query = "SELECT Sensor1 ,Sensor2 ,Sensor3 ,Time FROM Log WHERE ID_Device Like %s AND Date = %s AND Time BETWEEN %s AND %s" #query sensor value for calculate total unit command for select in mySqpl database
            cursor.execute(query,(ID_Device,Date,ts,te))
            Queryresult = cursor.fetchall()
            db.commit()
            if(len(Queryresult) == 1):
                sensor1.append(Queryresult[0][0]) #append sensor1 values to list
                sensor2.append(Queryresult[0][1]) #append sensor2 values to list
                sensor3.append(Queryresult[0][2]) #append sensor3 values to list
                timechart.append(str(ts))
            else:
                sensor1.append(0) #append sensor1 values to list
                sensor2.append(0) #append sensor2 values to list
                sensor3.append(0) #append sensor3 values to list
                timechart.append(str(ts))   	
        qc = QuickChart() #use QuickChart
        qc.width = 500	#set chart width
        qc.height = 300 #set chart height
        qc.device_pixel_ratio = 2.0
        qc.config = {
            "type": "line", #set chart type
            "fill": True,
            "data": {
                "labels": timechart,
                
                "datasets": [
                {
                    "label": "Sensor1", #set label name
                    "data": sensor1, #add data to chart            
                    "backgroundColor":["rgba(0,0,0,0.0)"], #set chart backgroundColor
                    "borderColor": ["rgba(255, 110, 2, 0.8)"], #set color line chart 
                    "lineTension" : "0.3", #set lineTension
                },
                {
                    "label": "Sensor2", #set label name
                    "data": sensor2, #add data to chart
                    "backgroundColor":["rgba(0,0,0,0.0)"], #set chart backgroundColor
                    "borderColor": ["rgba(0, 255, 0, 0.8)"], #set color line chart
                    "lineTension" : "0.3", #set lineTension
                },
                {
                    "label": "Sensor3", #set label name
                    "data": sensor3, #add data to chart
                    "backgroundColor":["rgba(0,0,0,0.0)"], #set chart backgroundColor
                    "borderColor": ["rgba(255, 0, 127, 0.8)"], #set color line chart
                    "lineTension" : "0.3", #set lineTension
                }
                ]
            },
            "options" : {
                "title" : {
                  "display" : "true", #show title
                  "text" : 'Unit', #set title
                  "position" : 'left', #set position title
                  "fontSize" : 15, #set titel fontSize 
                },
            },
	    }
        #print("timechart " + str(timechart) + " " + "sensor1 " + str(sensor1) + " " + "Sensor2 " + str(sensor2) + " " + "Sensor3 " + str(sensor3))
        print(qc.get_short_url()) #get chart URL
        return qc.get_short_url() #return chart URL
    else:
    	return False
#################################################################################    	 
@app.get("/get_Totals/{ID_Device}/{ID_User}") #get path connect to api
def read_get_Totals(ID_Device,ID_User): #read vales form api path
    userDeviceQuery = "SELECT ID_Device FROM Users_Device WHERE ID_User Like %s AND ID_Device Like %s" # SELECT records from the table
    cursor.execute(userDeviceQuery,(ID_User,ID_Device,)) #fetching all records from the 'cursor' object
    userDeviceQueryresult = cursor.fetchall() #fetching all records from the 'cursor' object
    db.commit()
    if(len(userDeviceQueryresult) != 0):
        total = []
        x = datetime.datetime.now()    
        month = int(x.strftime("%m"))
        year = int(x.strftime("%Y"))
        if(year%4 != 0):
            fm = feb28
        else:
            fm = feb29    
        dateStrat = x.strftime("%Y-%m-1")
        dateEnd = x.strftime("%Y-%m-" + str(fm[month-1]))
        query = """SELECT Sensor1 ,Sensor2 ,Sensor3 FROM Log WHERE ID_Device Like %s AND Date BETWEEN %s AND %s""" #query sensor value for calculate total unit command for select in mySqpl database
        cursor.execute(query,(ID_Device,dateStrat,dateEnd))
        Queryresult = cursor.fetchall()
        db.commit()        
        #print(Queryresult)
        if(len(Queryresult) != 0): #check ID_Device and Date form table
            sensor1 = 0.0
            sensor2 = 0.0 
            sensor3 = 0.0 
            #print(week + " Queryresult : " + str(Queryresult) + " Length : " + str(len(Queryresult)))                             
            for k in range(len(Queryresult)):          
                sensor1 += Queryresult[k][0] #plus all sensor1 values in month
                sensor2 += Queryresult[k][1] #plus all sensor2 values in month
                sensor3 += Queryresult[k][2] #plus all sensor3 values in month
            total = [round(sensor1,3),round(sensor2,3),round(sensor3,3)] #create list
            return total     
        else:
        	return [0,0,0]
    else:
        return False
#################################################################################








#################################################################################
def line_text(message,LINE_ACCESS_TOKEN):	
    msg = urllib.parse.urlencode({"message":message})
    LINE_HEADERS = {'Content-Type':'application/x-www-form-urlencoded',"Authorization":"Bearer "+LINE_ACCESS_TOKEN}
    session = requests.Session()
    session_post = session.post(URL_LINE, headers=LINE_HEADERS, data=msg) #send message to line noyi
    x = session_post.text.split(',') #get status code
    y = x[0].split(':') #get status code
    return y[1] #return status code
#################################################################################
