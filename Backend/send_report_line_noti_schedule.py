import datetime
from datetime import date
import mysql.connector as mysql

import requests, json
import urllib.parse
import sys

import schedule
import time

URL_LINE = "https://notify-api.line.me/api/notify" 



feb28 = [31,28,31,30,31,30,31,31,30,31,30,31] # 365 days in year
feb29 = [31,29,31,30,31,30,31,31,30,31,30,31] # 366 days in year
msg = ""
mode = 0

def line_text(message,LINE_ACCESS_TOKEN):	
    msg = urllib.parse.urlencode({"message":message})
    LINE_HEADERS = {'Content-Type':'application/x-www-form-urlencoded',"Authorization":"Bearer "+LINE_ACCESS_TOKEN}
    session = requests.Session()
    session_post = session.post(URL_LINE, headers=LINE_HEADERS, data=msg) #send message to line notify
    x = session_post.text.split(',') #get status code
    y = x[0].split(':') #get status code
    return y[1] #return status code

def line_noti():
    mode = 0
    x = datetime.datetime.now()
    date = x.strftime("%Y-%m-%d")
    day = int(x.strftime("%d"))
    
    week = x.strftime("%A")
    month = int(x.strftime("%m"))
    year = int(x.strftime("%Y"))
    TN = x.strftime("%H:%M")
    if(mode == 0):
            print("Mode : "+str(mode))
            mode = 1
            ########################################connect MySQL########################################
            db = mysql.connect(
            host = "localhost", 
            user = "********", #replace ******** with user mysql
            passwd = "********", #replace ******** with pass mysql
            database = "********" #replace ******** with database name
            )
            cursor = db.cursor()
            ########################################connect MySQL########################################
            if(int(year)%4 != 0):
                fm = feb28
            else:
                fm = feb29
            while(mode == 1):
                #try:
                    print("Mode : "+str(mode))
                    notiQuery = "SELECT ID_User, line_noti_Token FROM Nontification WHERE Status = 1 " #comand for select in mySqpl database
                    cursor.execute(notiQuery)
                    notiQueryresult = cursor.fetchall()
                    db.commit()
                    mode = 2
                #except Exception:
                    #print("Fail SELECT try again!!")
                    #pass
            print("notiQueryresult : " + str(notiQueryresult))
            for i in range(len(notiQueryresult)):
                while(mode == 2):
                    try:
                        print("Mode : "+str(mode))
                        userDevie_Query = "SELECT ID_User, ID_Device FROM Users_Device WHERE ID_User = %s " #comand for select in mySqpl database
                        cursor.execute(userDevie_Query,(notiQueryresult[i][0],))
                        userDevieQueryresult = cursor.fetchall()
                        db.commit()
                        mode = 3
                    except Exception:
                        print("Fail SELECT ID_User and ID_Device try again!!")
                        pass
                print("userDevieQueryresult : " + str(userDevieQueryresult))
                for j in range(len(userDevieQueryresult)):
                    if(int(day) != 1 and mode == 3):
                        sensor1today = 0.0
                        sensor2today = 0.0
                        sensor3today = 0.0
                        sensor1day7 = 0.0
                        sensor2day7 = 0.0
                        sensor3day7 = 0.0
                        sensor1toweek = 0.0
                        sensor2toweek = 0.0
                        sensor3toweek = 0.0
                        sensor1tolastweek = 0.0
                        sensor2tolastweek = 0.0
                        sensor3tolastweek = 0.0
                        print("Mode : "+str(mode) + " " + "(day) != 1")
                        if(week != "Sunday"): #week != "Sunday"    
                            msg = "รายงานการใช้ไฟฟ้าภายใน 1 วันที่ผ่านมาของกล่องรายงานการใช้ไฟฟ้า " + str(userDevieQueryresult[j][1]) + " "                    
                            if(month == 1 and (day - 1) < 1):
                                y = year - 1  
                                d = 31 - 1
                                yesterday = x.strftime(str(y)+"-12-"+str(d)) #Set the date format used in the search.
                            elif((day - 1) < 1):
                                d = fm[month-2]
                                m = month - 1
                                yesterday = x.strftime(str(year)+"-" + str(m) + "-"+str(d)) #Set the date format used in the search.
                            elif((day - 1) > 0):
                                d = day - 1
                                m = month
                                yesterday = x.strftime(str(year)+"-" + str(m) + "-"+str(d)) #Set the date format used in the search.
                            while(mode == 3):
                                    print("Mode : "+str(mode))
                                    query = "SELECT Sensor1 ,Sensor2 ,Sensor3 FROM Log WHERE ID_Device Like %s AND Date = %s" #query sensor value for calculate total unit comand for select in mySqpl database
                                    cursor.execute(query,(userDevieQueryresult[j][1],yesterday))
                                    Queryresult = cursor.fetchall()
                                    db.commit()
                                    if(len(Queryresult) != 0):
                                        print(week + " Queryresult : " + str(Queryresult) + " Length : " + str(len(Queryresult)))      
                                        ####### calculate Query result for totals #######                  
                                        for k in range(len(Queryresult)):
                                            sensor1today += Queryresult[k][0]
                                            sensor2today += Queryresult[k][1]
                                            sensor3today += Queryresult[k][2]
                                        print("sensor1today " + str(sensor1today) + " " + "sensor2today " + str(sensor2today) + " " + "sensor3today " + str(sensor3today)) 
                                        ####### calculate Query result for totals #######
                                    mode = 4                          
                            
                            if(month == 1 and (day - 7) < 1):
                                y = year - 1                   
                                d = 31 - ((day - 7)*(-1))
                                date7 = x.strftime(str(y)+"-12-"+str(d)) #Set the date format used in the search.
                            elif((day - 7) < 1):                            
                                d = fm[month-2] + (day - 7)
                                m = month-1
                                date7 = x.strftime(str(year)+"-" + str(m) + "-"+str(d)) #Set the date format used in the search.        
                            elif((day - 7) > 0):
                                d = day - 6
                                m = month
                                date7 = x.strftime(str(year)+"-" + str(m) + "-"+str(d)) #Set the date format used in the search.
                                
                            
                            while(mode == 4):
                                #try:
                                    print("Mode : "+str(mode))
                                    print(date7)
                                    query = "SELECT Sensor1 ,Sensor2 ,Sensor3 FROM Log WHERE ID_Device Like %s AND Date = %s" #query sensor value for calculate total unit 
                                    cursor.execute(query,(userDevieQueryresult[j][1],date7))
                                    date7Queryresult = cursor.fetchall()
                                    db.commit()
                                    ####### calculate Query result for totals #######
                                    if(len(date7Queryresult) != 0):
                                        for k in range(len(date7Queryresult)):
                                            sensor1day7 += date7Queryresult[k][0]
                                            sensor2day7 += date7Queryresult[k][1]
                                            sensor3day7 += date7Queryresult[k][2]
                                    ####### calculate Query result for totals #######
                                    mode = 5
                                #except Exception:
                                    #print("Fail SELECT Log try again!!")
                                    #pass
                            
                            if(sensor1day7 == 0):
                                msg += "มีการใช้ไฟฟ้าที่ sensor1 ทั้งหมด " + str(round(sensor1today,4)) + " unit"
                            elif(sensor1day7 < sensor1today):
                                msg += "sensor1 มีการใช้ไฟฟ้ามากกว่าวันเดียวกันในสัปดาห์ที่ผ่านมา " + str(round((sensor1today - sensor1day7),4)) + " unit และใช้ไปทั้งหมด " + str(round(sensor1today,4)) + " unit"
                            elif(sensor1day7 > sensor1today):
                                msg += "sensor1 มีการใช้ไฟฟ้าน้อยกว่าวันเดียวกันในสัปดาห์ที่ผ่านมา " + str(sensor1day7 - sensor1today) + " unit และใช้ไปทั้งหมด " + str(round(sensor1today,4)) + " unit"
                            else:
                                msg += "มีการใช้ไฟฟ้าที่ sensor1 ทั้งหมด " + str(round(sensor1today,4)) + "unit"
                            if(sensor2day7 == 0):
                                msg += " มีการใช้ไฟฟ้าที่ sensor2 ทั้งหมด " + str(round(sensor2today,4)) + " unit"
                            elif(sensor2day7 < sensor2today):
                                msg += " sensor2 มีการใช้ไฟฟ้ามากกว่าวันเดียวกันในสัปดาห์ที่ผ่านมา " + str(round((sensor2today - sensor2day7),4)) + " unit และใช้ไปทั้งหมด " + str(round(sensor2today,4)) + " unit"
                            elif(sensor2day7 > sensor2today):
                                msg += " sensor2 มีการใช้ไฟฟ้าน้อยกว่าวันเดียวกันในสัปดาห์ที่ผ่านมา " + str(round((sensor2day7 - sensor2today),4)) + " unit และใช้ไปทั้งหมด " + str(round(sensor2today,4)) + " unit"
                            else:
                                msg += " มีการใช้ไฟฟ้าที่ sensor2 ทั้งหมด " + str(round(sensor2today,4)) + "unit"
                            if(sensor3day7 == 0):
                                msg += " มีการใช้ไฟฟ้าที่ sensor3 ทั้งหมด " + str(round(sensor3today,4)) + " unit"
                            elif(sensor3day7 < sensor3today):
                                msg += " sensor3 มีการใช้ไฟฟ้ามากกว่าวันเดียวกันในสัปดาห์ที่ผ่านมา " + str(round((sensor3today - sensor3day7),4)) + " unit และใช้ไปทั้งหมด " + str(round(sensor3today,4)) + " unit"
                            elif(sensor3day7 > sensor3today):
                                msg += " sensor3 มีการใช้ไฟฟ้าน้อยกว่าวันเดียวกันในสัปดาห์ที่ผ่านมา " + str(round((sensor3day7 - sensor3today),4)) + " unit และใช้ไปทั้งหมด " + str(round(sensor3today,4)) + " unit"
                            else:
                                msg += " มีการใช้ไฟฟ้าที่ sensor3 ทั้งหมด " + str(round(sensor3today,4)) + "unit"
                            msgStatus = line_text(msg,notiQueryresult[i][1]) #send message to line noti and return status code
                            print("Line noti mess : " + msg + " " + "msgStatus : " + msgStatus)
                            msg = ""
                        else:
                            msg = "รายงานการใช้ไฟฟ้าภายใน 1 สัปดาห์ที่ผ่านมาของกล่องรายงานการใช้ไฟฟ้า " + str(userDevieQueryresult[j][1]) + " "                            
                            if(month == 1 and (day - 7) < 1):
                                y = year - 1                   
                                d = 31 - ((day - 7)*(-1))
                                date7 = x.strftime(str(y)+"-12-"+str(d)) #Set the date format used in the search.
                            elif((day - 7) < 1):                            
                                d = fm[month-2] - ((day - 7)*(-1))
                                m = month-1
                                date7 = x.strftime(str(year)+"-" + str(m) + "-"+str(d)) #Set the date format used in the search.
                            elif((day - 7) > 0):
                                d = day - 7
                                m = month
                                date7 = x.strftime(str(year)+"-" + str(m) + "-"+str(d)) #Set the date format used in the search.
                            print(date7)
                            if(month == 1 and (day - 1) < 1):
                                y = year - 1  
                                d = 31 - 1
                                yesterday = x.strftime(str(y)+"-12-"+str(d)) #Set the date format used in the search.
                            elif((day - 1) < 1):
                                d = fm[month-2]
                                m = month - 1
                                yesterday = x.strftime(str(year)+"-" + str(m) + "-"+str(d)) #Set the date format used in the search.
                            elif((day - 1) > 0):
                                d = day - 1
                                m = month
                                yesterday = x.strftime(str(year)+"-" + str(m) + "-"+str(d)) #Set the date format used in the search.
                            while(mode == 3):
                                try:    
                                    print("Mode : "+str(mode))                            
                                    query = "SELECT Sensor1 ,Sensor2 ,Sensor3 FROM Log WHERE ID_Device Like %s AND Date BETWEEN %s AND %s"
                                    cursor.execute(query,(userDevieQueryresult[j][1],date7,yesterday))
                                    weekQueryresult = cursor.fetchall()
                                    db.commit()
                                    ####### calculate Query result for totals #######
                                    if(len(weekQueryresult) != 0):
                                        print("Queryresult : " + str(weekQueryresult) + " " + "Length : " + str(len(weekQueryresult)))                     
                                        for k in range(len(weekQueryresult)):
                                            sensor1toweek += weekQueryresult[k][0]
                                            sensor2toweek += weekQueryresult[k][1]
                                            sensor3toweek += weekQueryresult[k][2]
                                        print("sensor1today " + str(sensor1toweek) + " " + "sensor2today " + str(sensor2toweek) + " " + "sensor3today " + str(sensor3toweek)) 
                                    #******* calculate Query result for totals ******#
                                    mode = 4
                                except Exception:
                                    print("Fail SELECT Log try again!!")
                                    pass
                            
                            ####### calculate day and month for Query #######
                            if(month == 1 and (day - 8) < 1):
                                y = year - 1                   
                                d = 31 - ((day - 8)*(-1))
                                lastweekday = x.strftime(str(y)+"-12-"+str(d)) #Set the date format used in the search.
                            elif((day - 8) < 1):                            
                                d = fm[month-2] - ((day - 8)*(-1))
                                m = month-1
                                lastweekday = x.strftime(str(year)+"-" + str(m) + "-"+str(d)) #Set the date format used in the search.
                            elif((day - 8) > 0):
                                d = day - 8
                                m = month
                                lastweekday = x.strftime(str(year)+"-" + str(m) + "-"+str(d)) #Set the date format used in the search.
                            print(lastweekday)
                            if(month == 1 and (day - 14) < 1):
                                y = year - 1                   
                                d = 31 - ((day - 14)*(-1))
                                lastweekday7 = x.strftime(str(y)+"-12-"+str(d)) #Set the date format used in the search.
                            elif((day - 14) < 1):                            
                                d = fm[month-2] - ((day - 14)*(-1))
                                m = month-1
                                lastweekday7 = x.strftime(str(year)+"-" + str(m) + "-"+str(d)) #Set the date format used in the search.
                            elif((day - 14) > 0):
                                d = day - 14
                                m = month
                                lastweekday7 = x.strftime(str(year)+"-" + str(m) + "-"+str(d)) #Set the date format used in the search.
                            print(lastweekday7)
                            #******* calculate day and month for Query ******#
                            while(mode == 4):
                                try:
                                    print("Mode : "+str(mode))
                                    query = "SELECT Sensor1 ,Sensor2 ,Sensor3 FROM Log WHERE ID_Device Like %s AND Date BETWEEN %s AND %s"
                                    cursor.execute(query,(userDevieQueryresult[j][1],lastweekday7,lastweekday))
                                    lastweekday7Queryresult = cursor.fetchall()
                                    db.commit()
                                    ####### calculate Query result for totals #######
                                    if(len(lastweekday7Queryresult) != 0):
                                        print("Queryresult : " + str(lastweekday7Queryresult) + " " + "Length : " + str(len(lastweekday7Queryresult)))                     
                                        for k in range(len(lastweekday7Queryresult)):
                                            sensor1tolastweek += lastweekday7Queryresult[k][0]
                                            sensor2tolastweek += lastweekday7Queryresult[k][1]
                                            sensor3tolastweek += lastweekday7Queryresult[k][2]
                                        print("sensor1toweek " + str(sensor1tolastweek) + " " + "sensor2tolastweek " + str(sensor2tolastweek) + " " + "sensor3today " + str(sensor3tolastweek))
                                    #******* calculate Query result for totals ******#
                                    mode = 5
                                except Exception:
                                    print("Fail SELECT Log try again!!")
                                    pass
                            
                            if(sensor1tolastweek == 0):
                                msg += "มีการใช้ไฟฟ้าที่ sensor1 ทั้งหมด " + str(round(sensor1toweek,4)) + " unit"
                            elif(sensor1tolastweek < sensor1toweek):
                                msg += "sensor1 มีการใช้ไฟฟ้ามากกว่าสัปดาห์ก่อน " + str(round((sensor1toweek - sensor1tolastweek),4)) + " unit และใช้ไปทั้งหมด " + str(round(sensor1toweek,4)) + " unit"
                            elif(sensor1tolastweek > sensor1toweek):
                                msg += "sensor1 มีการใช้ไฟฟ้าน้อยกว่าสัปดาห์ก่อน " + str(round((sensor1tolastweek - sensor1toweek),4)) + " unit และใช้ไปทั้งหมด " + str(round(sensor1toweek,4)) + " unit"
                            else:
                                msg += "มีการใช้ไฟฟ้าที่ sensor1 ทั้งหมด " + str(round(sensor1toweek,4)) + "unit"
                            if(sensor2tolastweek == 0):
                                msg += " มีการใช้ไฟฟ้าที่ sensor2 ทั้งหมด " + str(round(sensor2toweek,4)) + " unit"
                            elif(sensor2tolastweek < sensor2toweek):
                                msg += " sensor2 มีการใช้ไฟฟ้ามากกว่าสัปดาห์ก่อน " + str(round((sensor2toweek - sensor2tolastweek),4)) + " unit และใช้ไปทั้งหมด " + str(round(sensor2toweek,4)) + " unit"
                            elif(sensor2tolastweek > sensor1today):
                                msg += " sensor2 มีการใช้ไฟฟ้าน้อยกว่าสัปดาห์ก่อน " + str(round((sensor2tolastweek - sensor2toweek),4)) + " unit และใช้ไปทั้งหมด " + str(round(sensor2toweek,4)) + " unit"
                            else:
                                msg += " มีการใช้ไฟฟ้าที่ sensor2 ทั้งหมด " + str(round(sensor2toweek,4)) + "unit"
                            if(sensor3tolastweek == 0):
                                msg += " มีการใช้ไฟฟ้าที่ sensor3 ทั้งหมด " + str(round(sensor3toweek,4)) + " unit"
                            elif(sensor3tolastweek < sensor3toweek):
                                msg += " sensor3 มีการใช้ไฟฟ้ามากกว่าสัปดาห์ก่อน " + str(round((sensor3toweek - sensor3tolastweek),4)) + " unit today use " + str(round(sensor3toweek,4))+ " unit"
                            elif(sensor3tolastweek > sensor3toweek):
                                msg += " sensor3 มีการใช้ไฟฟ้าน้อยกว่าสัปดาห์ก่อน " + str(round((sensor3tolastweek - sensor3toweek),4)) + " unit today use " + str(round(sensor3toweek,4)) + " unit"
                            else:
                                msg += " มีการใช้ไฟฟ้าที่ sensor3 ทั้งหมด " + str(round(sensor3toweek,4)) + "unit"
                            msgStatus = line_text(msg,notiQueryresult[i][1]) #send message to line noti and return status code
                            print("Line noti mess : " + msg + " " + "msgStatus : " + msgStatus)
                            msg = ""
                        mode = 3
                    else:
                        msg = "รายงานการใช้ไฟฟ้าภายใน 1 เดือนที่ผ่านมาของกล่องรายงานการใช้ไฟฟ้า " + str(userDevieQueryresult[j][1]) + " "
                        sensor1monthAgo = 0.0
                        sensor2monthAgo = 0.0
                        sensor3monthAgo = 0.0
                        sensor1_2monthAgo = 0.0
                        sensor2_2monthAgo = 0.0
                        sensor3_2monthAgo = 0.0
                        ####### calculate day and month ago for Query #######
                        if(month == 1 and (month - 1) < 1):
                            y = year - 1  
                            ds = 1
                            de = 31                        
                            startday_monthAgo = x.strftime(str(y)+"-12-"+str(ds)) #Set the date format used in the search.
                            endday_monthAgo = x.strftime(str(y)+"-12-"+str(de)) #Set the date format used in the search.
                        elif((month - 1) < 1):
                            ds = 1
                            de = fm[month-2] 
                            m = month - 1
                            y = year - 1
                            startday_monthAgo = x.strftime(str(y)+"-" + str(m) + "-"+str(ds)) #Set the date format used in the search.
                            endday_monthAgo = x.strftime(str(y)+"-" + str(m) + "-"+str(de)) #Set the date format used in the search.
                        elif((month - 1) > 0):
                            ds = 1
                            de = fm[month-2] 
                            m = month - 1                            
                            startday_monthAgo = x.strftime(str(year)+"-" + str(m) + "-"+str(ds)) #Set the date format used in the search.
                            endday_monthAgo = x.strftime(str(year)+"-" + str(m) + "-"+str(de)) #Set the date format used in the search.
                        #******* calculate day and month ago for Query ******#
                        while(mode == 3):
                            try:
                                print("Mode : "+str(mode))
                                monthAgo_Query = "SELECT Sensor1 ,Sensor2 ,Sensor3 FROM Log WHERE ID_Device Like %s AND Date BETWEEN %s AND %s" #query sensor value for calculate total unit 
                                cursor.execute(monthAgo_Query,(userDevieQueryresult[j][1],startday_monthAgo,endday_monthAgo))
                                monthAgo_Queryresult = cursor.fetchall()
                                db.commit()
                                ####### calculate Query result for totals #######
                                if(len(monthAgo_Queryresult) != 0):
                                    print("Queryresult : " + str(monthAgo_Queryresult) + " " + "Length : " + str(len(monthAgo_Queryresult)))                     
                                    for k in range(len(monthAgo_Queryresult)):
                                        sensor1monthAgo += monthAgo_Queryresult[k][0]
                                        sensor2monthAgo += monthAgo_Queryresult[k][1]
                                        sensor3monthAgo += monthAgo_Queryresult[k][2]
                                    print("sensor1monthAgo " + str(sensor1monthAgo) + " " + "sensor2monthAgo " + str(sensor2monthAgo) + " " + "sensor3monthAgo " + str(sensor3monthAgo))
                                #******* calculate Query result for totals ******#
                                mode = 4
                            except Exception:
                                print("Fail SELECT Log try again!!")
                                pass
                        
                        ####### calculate day and 2 month ago for Query #######
                        if(month == 1 and (month - 2) < 1):
                            y = year - 1  
                            ds = 1
                            de = fm[10]                     
                            startday_2monthAgo = x.strftime(str(y)+"-11-"+str(ds)) #Set the date format used in the search.
                            endday_2monthAgo = x.strftime(str(y)+"-11-"+str(de)) #Set the date format used in the search.
                        elif((month - 2) < 1):
                            y = year - 1 
                            ds = 1
                            de = fm[11] 
                            m = 12
                            startday_2monthAgo = x.strftime(str(y)+"-" + str(m) + "-"+str(ds)) #Set the date format used in the search.
                            endday_2monthAgo = x.strftime(str(y)+"-" + str(m) + "-"+str(de)) #Set the date format used in the search.
                        elif((month - 2) > 0):
                            ds = 1
                            de = fm[month-3] 
                            m = month - 2
                            startday_2monthAgo = x.strftime(str(year)+"-" + str(m) + "-"+str(ds)) #Set the date format used in the search.
                            endday_2monthAgo = x.strftime(str(year)+"-" + str(m) + "-"+str(de)) #Set the date format used in the search.
                        #******* calculate day and 2 month ago for Query ******#
                        while(mode == 4):
                            try:
                                print("Mode : "+str(mode))
                                twomonthAgo_Query = "SELECT Sensor1 ,Sensor2 ,Sensor3 FROM Log WHERE ID_Device Like %s AND Date BETWEEN %s AND %s" #query sensor value for calculate total unit 
                                cursor.execute(twomonthAgo_Query,(userDevieQueryresult[j][1],startday_2monthAgo,endday_2monthAgo))
                                twomonthAgo_Queryresult = cursor.fetchall()
                                db.commit()
                                ####### calculate Query 2 month ago result for totals #######
                                if(len(twomonthAgo_Queryresult) != 0):
                                    print("Queryresult : " + str(twomonthAgo_Queryresult) + " " + "Length : " + str(len(twomonthAgo_Queryresult)))                     
                                    for k in range(len(twomonthAgo_Queryresult)):
                                        sensor1_2monthAgo += twomonthAgo_Queryresult[k][0]
                                        sensor2_2monthAgo += twomonthAgo_Queryresult[k][1]
                                        sensor3_2monthAgo += twomonthAgo_Queryresult[k][2]
                                    print("sensor1_2monthAgo " + str(sensor1_2monthAgo) + " " + "sensor2_2monthAgo " + str(sensor2_2monthAgo) + " " + "sensor3_2monthAgo " + str(sensor3_2monthAgo))
                                #******* calculate Query 2 month ago result for totals ******#
                                mode = 5
                            except Exception:
                                print("Fail SELECT Log try again!!")
                                pass
                        
                        if(sensor1_2monthAgo == 0):
                            msg += "มีการใช้ไฟฟ้าที่ sensor1 ทั้งหมด " + str(round(sensor1monthAgo,4)) + " unit"
                        elif(sensor1_2monthAgo < sensor1monthAgo):
                            msg += "sensor1 มีการใช้ไฟฟ้ามากกว่าเดือนก่อน " + str(round((sensor1monthAgo - sensor1_2monthAgo),4)) + " unit และใช้ไปทั้งหมด " + str(round(sensor1monthAgo,4)) + " unit"
                        elif(sensor1_2monthAgo > sensor1monthAgo):
                            msg += "sensor1 มีการใช้ไฟฟ้าน้อยกว่าเดือนก่อน " + str(round((sensor1_2monthAgo - sensor1monthAgo),4)) + " unit และใช้ไปทั้งหมด " + str(round(sensor1monthAgo,4)) + " unit"
                        else:
                            msg += "มีการใช้ไฟฟ้าที่ sensor1 ทั้งหมด " + str(round(sensor1monthAgo,4)) + "unit"
                        if(sensor2_2monthAgo == 0):
                            msg += " sensor2 use " + str(round(sensor2monthAgo,4)) + " unit"
                        elif(sensor2_2monthAgo < sensor2monthAgo):
                            msg += " sensor2 มีการใช้ไฟฟ้ามากกว่าเดือนก่อน " + str(round((sensor2monthAgo - sensor2_2monthAgo),4)) + " unit และใช้ไปทั้งหมด " + str(round(sensor2monthAgo,4)) + " unit"
                        elif(sensor2_2monthAgo > sensor2monthAgo):
                            msg += " sensor2 มีการใช้ไฟฟ้าน้อยกว่าเดือนก่อน " + str(round((sensor2_2monthAgo - sensor2monthAgo),4)) + " unit และใช้ไปทั้งหมด " + str(round(sensor2monthAgo,4)) + " unit"
                        else:
                            msg += " มีการใช้ไฟฟ้าที่ sensor2 ทั้งหมด " + str(round(sensor2monthAgo,4)) + "unit"
                        if(sensor3_2monthAgo == 0):
                            msg += " มีการใช้ไฟฟ้าที่ sensor3 ทั้งหมด " + str(round(sensor3monthAgo,4)) + " unit"
                        elif(sensor3_2monthAgo < sensor3monthAgo):
                            msg += " sensor3 มีการใช้ไฟฟ้ามากกว่าเดือนก่อน " + str(round((sensor3monthAgo - sensor3_2monthAgo),4)) + " unit และใช้ไปทั้งหมด " + str(round(sensor3monthAgo,4))+ " unit"
                        elif(sensor3_2monthAgo > sensor3monthAgo):
                            msg += " sensor3 มีการใช้ไฟฟ้าน้อยกว่าเดือนก่อน " + str(round((sensor3_2monthAgo - sensor3monthAgo),4)) + " unit และใช้ไปทั้งหมด " + str(round(sensor3monthAgo,4)) + " unit"
                        else:
                            msg += " มีการใช้ไฟฟ้าที่ sensor3 ทั้งหมด " + str(round(sensor3monthAgo,4)) + "unit"
                        msgStatus = line_text(msg,notiQueryresult[i][1]) #send message to line noti and return status code
                        print("Line noti mess : " + msg + " " + "msgStatus : " + msgStatus)
                        msg = ""
                        print("Fin month")                        
                        mode = 3
            cursor.close() #close cursur mysql
            db.close() #close connection form mysql
            mode  = 0
            
schedule.every().day.at("08:00").do(line_noti) #use schedule call line_noti function every day at 08:00

while 1:
	schedule.run_pending()
	time.sleep(1)



