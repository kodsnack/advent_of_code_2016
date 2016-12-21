#Viktor Cder, Advent of Code 2016 Funkar endast i python3, för python2 ta bort end='\r'
import hashlib

def makePassword(key):
    password =[]
    i = 0
    while len(password) < 8:
        hash = hashlib.md5()
        hash.update(str(key+str(i)).encode('utf-8'))
        hashed = hash.hexdigest()
        if hashed[:5] == '00000':
            password.append(hashed[5])
        i +=1
    return ''.join(password)

def makePasswordAdvanced(key):
    password =['*']*8
    i = 0
    print("  Cracking: " +''.join(password), end='\r')
    while '*' in password:
        hash = hashlib.md5()
        hash.update(str(key+str(i)).encode('utf-8'))
        hashed = hash.hexdigest()
        if hashed[:5] == '00000':
            try:
                if password[int(hashed[5])] == '*':
                    password[int(hashed[5])]=hashed[6]
                print("  Cracking: "+''.join(password), end='\r')
            except IndexError:
                pass
            except ValueError:
                pass
        i +=1
    print('\n')
    return ''.join(password)

def main():
    testDoor = 'abc'
    actualDoor = 'ugkcyxxp'
    #password = makePassword(actualDoor)
    password2 = makePasswordAdvanced(actualDoor)
    print(password2)

if __name__ == '__main__':
    main()
