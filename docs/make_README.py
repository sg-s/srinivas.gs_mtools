# this script makes the readme at the root dir
# by looking all the files we have here

# this script converts all the markdown formatted
# documentation at the top of every method
# and links them together into a single 
# markdown documentation
 

import glob, os
from shutil import copyfile



# move the readme_header to root
copyfile("./docs/README_header.md","./README.md")

outfile = open('README.md','a')

# first show all the toolboxes

for toolbox in sorted(glob.glob("./*/",recursive=True)):
	if toolbox.find("+") > 0:

		# each toolbox gets a heading 
		outfile.write("\n # ")
		toolbox_name = toolbox.replace("/","")
		toolbox_name = toolbox_name.replace("+","")
		toolbox_name = toolbox_name.replace(".","")
		outfile.write("[" + toolbox_name + "](./" + toolbox_name + '/)')
		
		# make the table headings
		outfile.write("\n\n| Name | Use |")
		outfile.write("\n| -------- | ------- |")
		

		


		# now get all the files within that toolbox
		for file in sorted(glob.iglob(toolbox + '/*.m', recursive=False)):
			outfile.write('\n|')

			
			fname = file.replace(toolbox,"")
			fname = fname.replace(".m","")
			fname = fname.replace(".","")
			

			outfile.write(fname)
			outfile.write("|   |")

	outfile.write("\n\n")



outfile.close()





# 	filename = file.replace('.m','')
# 	filename = filename.strip()
# 	filename = filename.replace('@cpplab/','')


# 	print(filename)

# 	if len(filename) == 0:
# 		continue

# 	lines = tuple(open(file, 'r'))

# 	a = -1
# 	z = -1


# 	for i in range(0,len(lines)):
		
# 		thisline = lines[i].strip('#')
# 		thisline = thisline.strip()

# 		if thisline == filename:
# 			a = i
# 			break

# 	for i in range(0,len(lines)):
		
# 		thisline = lines[i].strip('%')
# 		thisline = thisline.strip()
			
# 		if thisline.find('function') == 0:
# 			z = i
# 			break


# 	if a < 0 or z < 0:
# 		continue

	
# 	out_file.write('\n\n')
# 	out_file.write('-------\n')


# 	for i in range(a,z):
# 		thisline = lines[i]
# 		thisline = thisline.replace('','')

# 		# insert hyperlinks to other methods 
# 		if thisline.lower().find('->cpplab.') != -1:

# 			link_name = thisline.replace('->','')
# 			link_name = link_name.strip()
# 			method_name = thisline.replace('->cpplab.','')
# 			method_name = method_name.strip()
# 			method_name = method_name.lower()
# 			link_url = '[' + link_name + '](' + method_root + method_name + ')'
# 			link_url = link_url.strip()
# 			link_url = '    * ' + link_url + '\n'
# 			out_file.write(link_url)


# 		else:
# 			out_file.write(thisline)



# 	out_file.write('\n\n\n')






