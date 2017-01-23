#!/usr/bin/python
# -*- coding: utf-8 -*-


print ''
print '***************************************************************************************'
print '*                                                                                     *'
print '*                              Advent of code 2016 21/12                               *'
print '*                             @MrInlumino - Anders Rosen                              *'
print '*                                                                                     *'
print '***************************************************************************************'
print ''


# ****************************************** challenge 1 ****************************************** 
print '********** Challenge 1 ************'

password = 'abcdefgh'


# Open input data file and read it into a string
instructions=[]
fo = open('21.data','r')
for line in fo:
	instructions.append(line.replace('\n',''))
fo.close()


def RotateMe(text,mode=0,steps=1):
  # Takes a text string and rotates
  # the characters by the number of steps.
  # mode=0 rotate right
  # mode=1 rotate left
  length=len(text)
 
  for step in range(steps):
  # repeat for required steps
 
    if mode==0:
      # rotate right
      text=text[length-1] + text[0:length-1]
    else:
      # rotate left
      text=text[1:length] + text[0]
 
  return text

# Loop over each instruction and execute them accordingly
for instruction in instructions:
    bd = instruction.split(' ')
    
    # Rotate
    if bd[0] == 'rotate':
        if bd[1] == 'right':
            password = RotateMe(password,0,int(bd[2]))
        if bd[1] == 'left':
            password = RotateMe(password,1,int(bd[2]))
        if bd[1] == 'based':
            IndexChar = bd[6]
            steps = password.index(IndexChar)
            if steps >=4: 
                steps +=2 
            else:
                steps +=1
            password = RotateMe(password,0,steps)
    
    # Swap specified positions
    if bd[0] == 'swap' and bd[1] == 'position':
        pos1 = int(bd[2])
        pos2 = int(bd[5])
        # Make sure pos1 is smaller than pos2
        if pos1 > pos2:
            tmp = pos1
            pos1 = pos2
            pos2 = tmp
        password = password[:pos1] + password[pos2] + password[pos1+1:pos2] + password[pos1] + password[pos2+1:]

    # Swap specified letters
    if bd[0] == 'swap' and bd[1] == 'letter':
        pos1 = password.index(bd[2])
        pos2 = password.index(bd[5])
        # Make sure pos1 is smaller than pos2
        if pos1 > pos2:
            tmp = pos1
            pos1 = pos2
            pos2 = tmp
        password = password[:pos1] + password[pos2] + password[pos1+1:pos2] + password[pos1] + password[pos2+1:]
    
    # Reverse the characters of a specified part of the string
    if bd[0] == 'reverse':
        pos1 = int(bd[2])
        pos2 = int(bd[4])
        reversedString = password[pos1:pos2+1][::-1]
        password = password[:pos1] + reversedString + password[pos2+1:]

    # Move a specified char to new position in string
    if bd[0] == 'move':
        startPos = int(bd[2])
        endPos = int(bd[5])
        charToMove = password[startPos]
        # Remove the character
        password = password[:startPos] + password[startPos+1:]
        password = password[:endPos] + charToMove + password[endPos:]

print 'Challenge 1: The resulting password is: %s' % password



# ****************************************** challenge 2 ****************************************** 
print '\n********** Challenge 2 ************'

password = 'fbgdceah'

# Open input data file and read it into a list in reversed order
instructions=[]
fo = open('21.data','r')
for line in fo:
	instructions.insert(0,line.replace('\n',''))
fo.close()

# A function that rotates characters whithin a string a specified number of steps
# mode=0 rotate right
# mode=1 rotate left
def RotateMe(text,mode=0,steps=1):
  length=len(text)
 
  for step in range(steps):
  # repeat for required steps
 
    if mode==0:
      # rotate right
      text=text[length-1] + text[0:length-1]
    else:
      # rotate left
      text=text[1:length] + text[0] 
  return text

# Loop over each instruction and execute them accordingly
for instruction in instructions:
    bd = instruction.split(' ')
    
    # Rotate
    if bd[0] == 'rotate':
        if bd[1] == 'right':
            # Rotate left instead
            password = RotateMe(password,1,int(bd[2]))
        if bd[1] == 'left':
            # Rotate right instead
            password = RotateMe(password,0,int(bd[2]))
        if bd[1] == 'based':
            # Rotate left
            IndexChar = bd[6]
            indx = password.index(IndexChar)
            if indx == 0: steps = 9 
            if indx == 1: steps = 1 
            if indx == 2: steps = 6 
            if indx == 3: steps = 2 
            if indx == 4: steps = 7 
            if indx == 5: steps = 3 
            if indx == 6: steps = 8 
            if indx == 7: steps = 4 
            password = RotateMe(password,1,steps)
    
    # Swap specified positions
    if bd[0] == 'swap' and bd[1] == 'position':
        pos1 = int(bd[2])
        pos2 = int(bd[5])
        # Make sure pos1 is smaller than pos2
        if pos1 > pos2:
            tmp = pos1
            pos1 = pos2
            pos2 = tmp
        password = password[:pos1] + password[pos2] + password[pos1+1:pos2] + password[pos1] + password[pos2+1:]

    # Swap specified letters
    if bd[0] == 'swap' and bd[1] == 'letter':
        pos1 = password.index(bd[2])
        pos2 = password.index(bd[5])
        # Make sure pos1 is smaller than pos2
        if pos1 > pos2:
            tmp = pos1
            pos1 = pos2
            pos2 = tmp
        password = password[:pos1] + password[pos2] + password[pos1+1:pos2] + password[pos1] + password[pos2+1:]
    
    # Reverse the characters of a specified part of the string
    if bd[0] == 'reverse':
        pos1 = int(bd[2])
        pos2 = int(bd[4])
        reversedString = password[pos1:pos2+1][::-1]
        password = password[:pos1] + reversedString + password[pos2+1:]

    # Move a specified char to new position in string
    if bd[0] == 'move':
        endPos = int(bd[2])
        startPos = int(bd[5])
        charToMove = password[startPos]
        # Remove the character
        password = password[:startPos] + password[startPos+1:]
        password = password[:endPos] + charToMove + password[endPos:]

print 'Challenge 2: The resulting password is: %s' % password