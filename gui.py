import tkinter as tk
from tkinter import messagebox
from oop_project import Hosiptalmanagement, Doctor, Patient

manager = Hosiptalmanagement()

root = tk.Tk()
root.title("Hospital Management System")
root.geometry("600x700")
root.configure(bg="#f0f0f0")

def add_doctor_action():
    try:
        name = ent_doc_name.get()
        doc_id = ent_doc_id.get()
        spec = ent_doc_spec.get()
        salary = ent_doc_salary.get()
        
        if not name or not doc_id:
            messagebox.showwarning("Input Error", "Please fill Name and ID!")
            return

        new_dr = Doctor(name, doc_id, "010...", "None", "o@mail.com", spec, salary, ["Sat"])
        manager.add_doctor(new_dr)
        messagebox.showinfo("Success", f"Dr. {name} added!")
    except Exception as e:
        messagebox.showerror("Error", str(e))

def add_patient_action():
    try:
        name = ent_pat_name.get()
        pat_id = ent_pat_id.get()
        illness = ent_pat_ill.get()
        height = ent_pat_height.get()
        weight = ent_pat_weight.get()

        if not name or not pat_id:
            messagebox.showwarning("Input Error", "Please fill Patient Name and ID!")
            return

        new_pat = Patient(name, pat_id, "012...", "None", "p@mail.com", height, weight, illness)
        manager.add_patient(new_pat)
        messagebox.showinfo("Success", f"Patient {name} added!")
    except Exception as e:
        messagebox.showerror("Error", str(e))

def show_all_action():
    display_win = tk.Toplevel(root)
    display_win.title("Hospital Records")
    display_win.geometry("500x400")
    
    txt = tk.Text(display_win)
    txt.pack(expand=True, fill='both')
    
    txt.insert(tk.END, "--- Doctors ---\n")
    for d in manager.doctors:
        txt.insert(tk.END, f"ID: {d.getid()} | Name: {d.name} | Spec: {d.speciality}\n")
    
    txt.insert(tk.END, "\n--- Patients ---\n")
    for p in manager.patients:
        txt.insert(tk.END, f"ID: {p.getid()} | Name: {p.name} | Illness: {p.illness}\n")

# UI Design
tk.Label(root, text="Doctor Section", font=("Arial", 14, "bold"), bg="#f0f0f0").pack(pady=5)
ent_doc_name = tk.Entry(root, width=40); ent_doc_name.pack(); tk.Label(root, text="Name").pack()
ent_doc_id = tk.Entry(root, width=40); ent_doc_id.pack(); tk.Label(root, text="ID").pack()
ent_doc_spec = tk.Entry(root, width=40); ent_doc_spec.pack(); tk.Label(root, text="Speciality").pack()
ent_doc_salary = tk.Entry(root, width=40); ent_doc_salary.pack(); tk.Label(root, text="Salary").pack()
tk.Button(root, text="Add Doctor", command=add_doctor_action, bg="green", fg="white").pack(pady=5)

tk.Label(root, text="----------------------------------", bg="#f0f0f0").pack()

tk.Label(root, text="Patient Section", font=("Arial", 14, "bold"), bg="#f0f0f0").pack(pady=5)
ent_pat_name = tk.Entry(root, width=40); ent_pat_name.pack(); tk.Label(root, text="Name").pack()
ent_pat_id = tk.Entry(root, width=40); ent_pat_id.pack(); tk.Label(root, text="ID").pack()
ent_pat_ill = tk.Entry(root, width=40); ent_pat_ill.pack(); tk.Label(root, text="Illness").pack()
ent_pat_height = tk.Entry(root, width=40); ent_pat_height.pack(); tk.Label(root, text="Height").pack()
ent_pat_weight = tk.Entry(root, width=40); ent_pat_weight.pack(); tk.Label(root, text="Weight").pack()
tk.Button(root, text="Add Patient", command=add_patient_action, bg="blue", fg="white").pack(pady=5)

tk.Button(root, text="Show All Data", command=show_all_action, width=20).pack(pady=20)

root.mainloop()