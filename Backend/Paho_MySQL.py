import paho.mqtt.client as mqtt
import mysql.connector as mysql
import datetime



def on_connect(client, userdata, flags, rc):  # The callback for when the client connects to the broker
    #print("Connected with result code {0}".format(str(rc)))  # Print result of connection attempt
    client.subscribe("saveLog/sub")  # Subscribe to the topic “saveLog/sub”, receive any messages published on it


def on_message(client, userdata, msg):  # The callback for when a PUBLISH message is received from the serve
        txt = str(msg.payload) #received msg
        x = txt.split("'")
        if len(x) != 0: #check size received msg
            y = x[1].split(",")
            x = datetime.datetime.now()
            date = x.strftime("%Y-%m-%d")
            time = x.strftime("%H:%M:%S")
            TS = x.strftime("%H:00:00")
            TE = x.strftime("%H:59:59")
        ##print("Time Start = " + TS + " Time End = " + TE)
        if len(y) == 4:
            if float(y[1]) > 0.00000000:
                unit1 = (float(y[1])/1000)/3600
            else:
                unit1 = 0.0
            if float(y[2]) > 0.00000000:
                unit2 = (float(y[2])/1000)/3600
            else:
                unit2 = 0.0
            if float(y[3]) > 0.00000000:
                unit3 = (float(y[3])/1000)/3600
            else:
                unit3 = 0.0
            ########################################connect MySQL########################################
            db = mysql.connect(
            host = "localhost",
            user = "********", #replace ******** with MySQL user
            passwd = "********", #replace ******** with MySQL password
            database = "********") #replace ******** with MySQL database name
            cursor = db.cursor()
            ########################################connect MySQL########################################
            try:
                values = (y[0], str(unit1), str(unit2), str(unit3), str(date), str(time)) #values for insert to database
                ## query for update
                query = """SELECT ID_Device ,Sensor1 ,Sensor2 ,Sensor3 FROM Log WHERE ID_Device Like %s AND Time BETWEEN %s AND %s AND Date BETWEEN %s AND %s""" #camand for select to database
                cursor.execute(query,(y[0],TS,TE,date,date,))
                records = cursor.fetchall() 
                db.commit()
                if len(records) == 0 and len(y) == 4:
                    try:
                        ## executing the insert with values
                        insert = "INSERT INTO Log (ID_Device, Sensor1, Sensor2, Sensor3, Date, Time) VALUES (%s, %s, %s, %s, %s, %s)"
                        cursor.execute(insert, values)
                        ## to make final output we have to run the 'commit()' method of the database object
                        db.commit()
                        print(cursor.rowcount, "record inserted")
                        cursor.close() #close cursur
                        db.close() #close connection form MySQL
                    except Exception:
                        print("Fail to save!!")
                        pass
                else:
                    if len(y) == 4:
                        if float(y[1]) > 0.00000000:
                            unit1 = (float(y[1])/1000)/3600
                        else:
                            unit1 = 0.00000000
                        if float(y[2]) > 0.00000000:
                            unit2 = (float(y[2])/1000)/3600
                        else:
                            unit2 = 0.0
                        if float(y[3]) > 0.00000000:
                            unit3 = (float(y[3])/1000)/3600
                        else:
                            unit3 = 0.0
                        try:			
                            temp1 = float(records[0][1]) + unit1
                            temp2 = float(records[0][2]) + unit2
                            temp3 = float(records[0][3]) + unit3
                            #print("######################################################################################")
                            #print("MQTT = " + str(unit1) + "-" + str(unit2) + "-" + str(unit3))
                            #print("Query = " + str(records[0][1]) + "-" + str(records[0][2]) + "-" + str(records[0][3])) 
                            #print("Result = " + str(temp1) + "-" + str(temp2) + "-" + str(temp3))
                            ##Update	    			
                            sql = """UPDATE Log SET Sensor1 = %s ,Sensor2 = %s ,Sensor3 = %s ,Date = %s ,Time = %s WHERE ID_Device Like %s AND Time BETWEEN %s AND %s AND Date BETWEEN %s AND %s""" # executing the insert with values
                            val = (str(temp1),str(temp2),str(temp3),date,time, y[0],TS,TE,date,date) #values for insert to database
                            cursor.execute(sql, val)	    			
                            db.commit() ## to make final output we have to run the 'commit()' method of the database object
                            print(cursor.rowcount, "record(s) updade")
                            cursor.close() #close cursor
                            db.close() #close connection form MySQL
                            #print("Update")
                            #print("######################################################################################")
                        except Exception:
                            print("Update Fail!!")
                            pass
            except Exception:
            	print("Fail MySQL")
            	pass	    	
        
        
            


client = mqtt.Client("digi_mqtt_test")  # Create instance of client with client ID “digi_mqtt_test”
client.on_connect = on_connect  # Define callback function for successful connection
client.on_message = on_message  # Define callback function for receipt of a message
# client.connect("m2m.eclipse.org", 1883, 60)  # Connect to (broker, port, keepalive-time)
client.username_pw_set("mymqtt", "myraspi")
client.connect('127.0.0.1', 1883)
client.loop_forever()  # Start networking daemon



