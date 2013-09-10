#!/usr/bin/python

import argparse
import sys
import paramiko

def RemoteUpload(hostIP, hostPassword, hostUsername, hostPort, filesToUpload, remoteLocation):
    import paramiko
#    print ('%s %s' % (hostIP,hostPort))
    transport = paramiko.Transport((hostIP,int(hostPort)))
    try:
        print('Connecting to %s'% hostIP),
        transport.connect(username = hostUsername, password = hostPassword)
        print('...Connected.')
        try:
            sftp = paramiko.SFTPClient.from_transport(transport)
            filesToUpload =  filesToUpload.split(',')
            for eachFile in filesToUpload :
                eachFileName = eachFile.split('/')
#                print eachFileName
                eachFileNameLength = len(eachFileName)
#                print eachFileNameLength
                exactFileName = eachFileName[eachFileNameLength-1]
#                print exactFileName
                if remoteLocation[-1] == '/':
                    newFile = "%s%s" % (remoteLocation,exactFileName)
                else:
                    newFile = "%s/%s" % (remoteLocation,exactFileName)
#                print ("%s - %s" % (eachFile, newFile))
                try:
                    print ("Uploading %s to %s" % (eachFile, newFile)),
                    sftp.put(eachFile, newFile)
                    print ('...OK!')
                except Exception as ex:
                    print( '...Error!')
		    print ex
            transport.close()
        except:
            print("Failed to upload to %s" % hostIP)

    except:
        print("...Failed!")

parser = argparse.ArgumentParser()

parser.add_argument('-c', '--serverip', help='specifies server VIP of server name', required=True)
#parser.add_argument('-m', '--mode', help='switch : specify "upload" or "download" (case sensitive)', choices=['upload', 'download'] )
parser.add_argument('-u', '--username', help='Remote host username', required=True)
parser.add_argument('-p', '--password', help='Remote host password', required=True)
parser.add_argument('-P', '--port', help='Remote host SSH port', required=True, type=int)
parser.add_argument('-l', '--localLocation', help='use with Download switch')
parser.add_argument('-r', '--remoteLocation', help='use with upload switch')
parser.add_argument('-f', '--files', help='mention the complete path of files you want to download or upload. Separate multiple files with (,) comma!')

args = parser.parse_args()


hostIP = args.serverip
hostPassword = args.password
hostUsername = args.username
hostPort = int(args.port)
filesNames = args.files
localLocation = args.localLocation
remoteLocation = args.remoteLocation
#copyMode = args.mode

RemoteUpload(hostIP, hostPassword, hostUsername, hostPort, filesNames, remoteLocation)


