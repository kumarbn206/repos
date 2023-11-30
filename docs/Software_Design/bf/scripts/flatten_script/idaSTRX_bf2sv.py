#  ----------------------------------------------------------------------------
#					 Copyright Message
#  ----------------------------------------------------------------------------
#
#  CONFIDENTIAL and PROPRIETARY
#  COPYRIGHT (c) NXP B.V. 2020
#
#  All rights are reserved. Reproduction in whole or in part is
#  prohibited without the written consent of the copyright owner.
#
#  CoReUse 5.0 information header.
#
#  ----------------------------------------------------------------------------
#					Design Information
#  ----------------------------------------------------------------------------
#
#  Organisation	   : BL RFP
#
#  File			   : idaSTRX_bf2sv.py
#  Date			   : Date: Tue Nov 30 22:25:49 2021
#  Revision		   : Revision: 1.0
#
#  Description	   :
#
#  Author		   : Salvatore Drago
#  Project		   : STRX-Onechip
#
#  ----------------------------------------------------------------------------
#					 Revision History
#  ----------------------------------------------------------------------------
#  $Log: idaSTRX_bf2sv.py.rca $
#  
#   Revision: 1.4 Fri Dec  3 17:50:29 2021 nlv17256
#   Salvo: map tempsensor1, tempsensor2,
#   tempsensor3, tempsensor4. into tempsensor[1], 
#   tempsensor[2],tempsensor[3], tempsensor[4],
#  
#   Revision: 1.3 Fri Dec  3 06:47:47 2021 nlv17256
#   Salvo: commented out openfile as many user do not have notepad++ installed
#  
#   Revision: 1.2 Wed Dec  1 20:45:25 2021 nlv17256
#   Salvo: fixing some typo
#  
#   Revision: 1.1 Thu Jan 14 19:34:20 2021 nlv17256
#   Salvo: first version of utility 
#  
#  ----------------------------------------------------------------------------
import os
import re
import sys
import time


global outfile

def bf_flatten_and_covert(bflibpath,fname,outfile):
	if os.path.isfile(os.path.realpath(fname)):
		infile=open(os.path.realpath(fname),'r')
		wholefile=infile.read()
		
		#remove comments
		comment_pattern_1=re.compile(r'(/\*([^*]|[\r\n]|(\*+([^*/]|[\r\n])))*\*+/)|(//.*)')
		comment_pattern_2=re.compile(r'//.+')
		wholefile=re.sub(comment_pattern_1,'',wholefile)
		wholefile=re.sub(comment_pattern_2,'',wholefile)
		
		#define include and nowhite for later linebyline processing
		include_pattern=re.compile(r'^\s*#include "([\w\W]*)"')
		nowhite_pattern=re.compile(r'\s')

		lines=wholefile.split('\n')
		for line in lines:
			include_path=re.search(include_pattern,line)
				
			if re.match(include_pattern,line):
				path=include_path.group(1)
				bf_flatten_and_covert(bflibpath,os.path.join(os.path.dirname(fname), path),outfile) #recursive
			else:
				line=re.sub(nowhite_pattern,"",line)
				if len(line)>0:
					line = line.split(";")[0]
					if  line.find(".") > -1 :
						if  line.find("RX1.") > -1 :
							line=line.replace('RX1.','RX[1].',1)
						if  line.find("RX2.") > -1 :
							line=line.replace('RX2.','RX[2].',1)
						if  line.find("RX3.") > -1 :
							line=line.replace('RX3.','RX[3].',1)
						if  line.find("RX4.") > -1 :
							line=line.replace('RX4.','RX[4].',1)
						if  line.find("TX1.") > -1 :
							line=line.replace('TX1.','TX[1].',1)
						if  line.find("TX2.") > -1 :
							line=line.replace('TX2.','TX[2].',1)
						if  line.find("TX3.") > -1 :
							line=line.replace('TX3.','TX[3].',1)
						if  line.find("TX4.") > -1 :
							line=line.replace('TX4.','TX[4].',1)
						if  line.find("RXADC1.") > -1 :
							line=line.replace('RXADC1.','ADC[1].',1)
						if  line.find("RXADC2.") > -1 :
							line=line.replace('RXADC2.','ADC[2].',1)
						if  line.find("RXADC3.") > -1 :
							line=line.replace('RXADC3.','ADC[3].',1)
						if  line.find("RXADC4.") > -1 :
							line=line.replace('RXADC4.','ADC[4].',1)
						if  line.find("TEMPSENSOR1.") > -1 :
							line=line.replace('TEMPSENSOR1.','TEMPSENSOR[1].',1)
						if  line.find("TEMPSENSOR2.") > -1 :
							line=line.replace('TEMPSENSOR2.','TEMPSENSOR[2].',1)
						if  line.find("TEMPSENSOR3.") > -1 :
							line=line.replace('TEMPSENSOR3.','TEMPSENSOR[3].',1)
						if  line.find("TEMPSENSOR4.") > -1 :
							line=line.replace('TEMPSENSOR4.','TEMPSENSOR[4].',1)
						if  line.find("RCOSC.") > -1 :
							line=line.replace('RCOSC.','RC_OSC.',1)
						if  line.find("LOIF.") > -1 :
							line=line.replace('LOIF.','LO_IF.',1)	
						line=line.replace(line.split('.')[0],line.split('.')[0].lower(),1)
					if  line.find("=") > -1 :
						if line.find("0x")<0 : 
							value = hex(int(line.split("=")[1]))
						else:
							value = line.split("=")[1]	
						value_dec = int(value,16)
						cmd = 'reg_model.' + line.split("=")[0] + '.set(\'d' + str(value_dec) + ');\n'
						cmd = cmd + 'reg_model' + '.' + cmd.split('.')[1] + '.' + cmd.split('.')[2] + '.update(status);'
						outfile.write(cmd+'\n')	
					elif line.find("sleep_bv") > -1 :
						line=line.split('sleep_bv(')[1]
						bf=line.split(',')[0]
						bfvalue=line.split(',')[1]
						bfvalue=bfvalue.split(')')[0]
						cmd= 'sleep_bv("' + bf.split(".")[0] + '","' + bf.split(".")[1] + '","' + bf.split(".")[2] + '",\'d' + str(int(bfvalue,0)) + ',100);'
						outfile.write(cmd+'\n')
					elif line.find("sleep") > -1 :
						line = line.split('sleep(')[1]
						line = line.split(')')[0]
						cmd  = '#' + line + 'us'
						outfile.write(cmd+'\n')

	else:
		outfile.write('#*********************************************************************\n')
		outfile.write('# NOT FOUND!!!\n')
		outfile.write('#*********************************************************************\n')
		print('--------------------------------------------------------------------')
		print('>E: Error!!! Could not find .bf file:')
		print('.'+os.path.realpath(bflibpath+fname).split(os.getcwd())[1])
		print('--------------------------------------------------------------------')
		outfile.close()
		quit()

def bf2sv(bflibpath, pylibpath, fname, openfile = False):
		
	pwd             = os.getcwd()	
	ofile           = os.getcwd() + pylibpath + os.path.basename(fname).split('.')[0] + '.sv'
	outfile         = open(ofile,'w')

	os.chdir(os.path.realpath(pwd + bflibpath))
	bf_flatten_and_covert(bflibpath,fname,outfile)
	
	outfile.close()
	print("\n...All right!!! Convertion done check it out in\n\n" + os.path.realpath(ofile))

	if openfile:
		os.system('call \"C:\\Program Files\\Notepad++\\Notepad++.exe\"  \"'+ os.path.realpath(ofile)+'\"')
	os.chdir(pwd)

			

if __name__ == '__main__':
	
	#usage 
	#call python STRX_bf2sv.py ./../../ ./../../idaStrxExamples/sv_library/ ./idaStrxExamples/idaStrxSx_76G_CW_to_RFATB.bf
	
	__relpath_bflib__ = sys.argv[1] # first argument is the relpath of bf_library          example ./../../
	__relpath_svlib__ = sys.argv[2] # second argument is the path of output sv_library     example ./../../idaStrxExamples/sv_library/
									# third argument is bffile to convert                  example ./idaStrxExamples/idaStrxSx_76G_CW_to_RFATB.bf
	
	if not os.path.isdir(__relpath_svlib__ ):
		try:  
			os.mkdir(__relpath_svlib__ )
		except OSError:  
			print ("Creation of the directory %s failed" % __relpath_svlib__ )
			quit()
		else:  
			print ("Successfully created the directory %s " % __relpath_svlib__ )
	
	for arg in sys.argv[3:]: # more than one file can be parsed together. execution will be in series
		 
		fname           = os.path.realpath(__relpath_bflib__+arg)
								
		if fname.split('.')[1] == 'bf':
			bf2sv(__relpath_bflib__,__relpath_svlib__,fname,False)
			ofile           = os.getcwd() + __relpath_svlib__ + os.path.basename(fname).split('.')[0] + '.py'
			
		else:
			print('Usage: python STRX_bf2sv.py relpath_bflib relpath_svlib ./bffile.bf')

