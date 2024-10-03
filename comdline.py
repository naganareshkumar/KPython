# create a command line simulator
import cmd
import sys
import subprocess
import os


class Naresh(cmd.Cmd):
    # prompt = ">> "

        
    def do_naresh(self, line):
        fname = line.strip()
        if fname:
            print(f"Running Python script: {fname}")
            cdir = os.getcwd()
            spath = os.path.join(cdir, fname)
            try:
                # Execute the Python script
                result = subprocess.run([sys.executable, spath], capture_output=True, text=True)
                print(result.stdout)
                if result.stderr:
                    print(f"Error: {result.stderr}")
            except Exception as e:
                print(f"Failed to run script: {e}")
        else:
            print("No filename provided")
        
    def precmd(self,line):
        print("Before execution")
        return line
    
    def postcmd(self,stop, line):
        print("After command")
        return stop
    
    def preloop(self):
        print("Intialization before cli loop")
        
    def postloop(self):
        print("finilization after the cli Loop")
    
        
    
# command to exit
    def do_quit(self, line):
        return True

if __name__ == "__main__":
    Naresh().cmdloop()
