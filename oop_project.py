from abc import ABC,abstractmethod
class User(ABC):
    def __init__(self,name,id,tel_num,another_tel_num,email):
     self.name=name
     self._id=id
     self._tel_num=tel_num
     self._another_tel_num=another_tel_num
     self._email=email 
   
    def displayinfo(self):
     pass

    def setname(self,name):
     self.name=name
    def getname(self):
     return self.name

    def setid(self,id):
     self._id=id
    def getid(self):
     return self._id
 
    def settelnum(self,tel_num):
     if len(tel_num)==11:
      self._tel_num=tel_num
     else:
      print("invalid phone number")
       
    def gettelp(self):
    
     return self._tel_num

    def setanothertelp(self,another_tel_num):
     if len(another_tel_num)==11:
      self._another_tel_num=another_tel_num
     else:
      print("invalid number")

    def getanothertelp(self):
     return self._another_tel_num
    def setemail(self,email):
     if "@" in email:
      self._email=email
     else:
      print("invalid email")
    def getemail(self):
     return self._email
    
 
class Doctor(User):
 def __init__(self, name, id, tel_num, another_tel_num, email,speciality,salary,avaliable_days):
  super().__init__(name, id, tel_num, another_tel_num, email)
  self.speciality=speciality
  self._salary=salary
  self.avaliable_days=avaliable_days
  
            
 def displayinfo(self): 
   print(f"My name is doctor {self.name} and my id is {self._id} my speciality is {self.speciality} and i earn{self._salary} and i have two phone numbers the first is {self._tel_num} and the seconde is {self._another_tel_num}")
def setsalary(self,salary):
 self._salary=salary
def getsalary(self):
 return self._salary


class Patient(User):
    def __init__(self, name, id, tel_num, another_tel_num, email, height, weight, illness):
        super().__init__(name, id, tel_num, another_tel_num, email)
        self.height = height
        self.weight = weight
        self.illness = illness

    def displayinfo(self):
        print(f"Patient Name: {self.name}, ID: {self.getid()}, Illness: {self.illness}")

class Hosiptalmanagement:
    def __init__(self):
        self.doctors = []
        self.patients = []

    def add_doctor(self, doctor_obj):
        self.doctors.append(doctor_obj)
        print(f"dr {doctor_obj.name} is added successfly")

    def add_patient(self, patient_obj):
        # التأكد إن المريض بيضاف للستة الصح
        self.patients.append(patient_obj)
        print(f"patient {patient_obj.name} is added successfly")

    def show_all_doctors(self):
        print("\n--- All Doctors ---")
        for d in self.doctors:
            d.displayinfo()

    def show_all_patients(self):
        print("\n--- All Patients ---")
        if not self.patients:
            print("No patients found.")
        for p in self.patients:
            p.displayinfo()

    def search_doctor(self, search_id):
        for doc in self.doctors:
            if str(doc.getid()) == str(search_id):
                return doc
        return None

    def search_patient(self, search_id):
        for pat in self.patients:
            if str(pat.getid()) == str(search_id):
                return pat
        return None

    def delete_doctor(self, search_id):
        doc = self.search_doctor(search_id)
        if doc:
            self.doctors.remove(doc)
            print(f"Dr. {doc.name} removed.")

    def delete_patient(self, search_id):
        pat = self.search_patient(search_id)
        if pat:
            self.patients.remove(pat)
            print(f"Patient {pat.name} removed.")

manager = Hosiptalmanagement()


dr_omar = Doctor("Omar Engineering", "2026", "01022055321", "01123456789", "omar@alexu.edu", "AI & Robotics", 30000, ["Sat", "Tue"])
patient_ehab = Patient("Ehab", "501", "01234567890", "01512345678", "ehab@mail.com", 175, 80, "Flu")



manager.add_doctor(dr_omar)
manager.add_patient(patient_ehab)


manager.show_all_doctors()
manager.show_all_patients()


found_dr = manager.search_doctor("2026")



manager.delete_patient("501") 

manager.show_all_patients()