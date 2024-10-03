
''' Function defined in isPrime Class will result given number is prime or not '''
class isPrime(object):

     
    def isPrimenumber(self, number):
        count = 0
        # Check if number less than 2
        if number <= 2:
            return number
        # A number divides itself and not divide by other number except 1
        for i in range(2, number):
            if((number % i ==0)):
                count=count+1
        if (count==0):
            return True
        else:
            return False

isp = isPrime()
print(isp.isPrimenumber(9))
