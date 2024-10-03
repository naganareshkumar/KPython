# define a class with a member variable name and a show method. Use print to show the name
class methodShow(object):
    # member variable": name
   
    # This methd prints member vairbale name
    def show(self,name):
        print("Member variable ", name)

    # Created object access show method
varShow = methodShow()
varShow.show("DNA")
