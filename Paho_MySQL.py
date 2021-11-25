import paho.mqtt.client as mqtt
import mysql.connector as mysql
import datetime


db = mysql.connect(
    host = "localhost",
    user = "Tony24Hours",
    passwd = "!Tony2557",
    database = "MQTT_Save"
)

cursor = db.cursor()

query = "INSERT INTO History (Device, Sensors, Unit, Date, Time) VALUES (%s, %s, %s, %s, %s)"

def on_connect(client, userdata, flags, rc):  # The callback for when the client connects to the broker
    print("Connected with result code {0}".format(str(rc)))  # Print result of connection attempt
    client.subscribe("mynew/test")  # Subscribe to the topic “digitest/test1”, receive any messages published on it


def on_message(client, userdata, msg):  # The callback for when a PUBLISH message is received from the serve
    txt = str(msg.payload)
    x = txt.split("'")
    y = x[1].split(",")
    print(y)  # Print a received msg
    x = datetime.datetime.now()
    date = x.strftime("%Y-%m-%d")
    time = x.strftime("%H:%M:%S")

    values = (y[0], y[1], y[2], str(date), str(time))
    
    ## executing the query with values
    cursor.execute(query, values)
    ## to make final output we have to run the 'commit()' method of the database object
    db.commit()
    print(cursor.rowcount, "record inserted")


client = mqtt.Client("digi_mqtt_test")  # Create instance of client with client ID “digi_mqtt_test”
client.on_connect = on_connect  # Define callback function for successful connection
client.on_message = on_message  # Define callback function for receipt of a message
# client.connect("m2m.eclipse.org", 1883, 60)  # Connect to (broker, port, keepalive-time)
client.username_pw_set("mymqtt", "myraspi")
client.connect('127.0.0.1', 1883)
client.loop_forever()  # Start networking daemon
