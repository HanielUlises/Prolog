import tkinter as tk
from tkinter import messagebox
from swiplserver import PrologMQI


def query_swi_prolog(consulta):
    with PrologMQI() as mqi:
        with mqi.create_thread() as prolog_thread:
            prolog_thread.query("consult('marcos-animalia.pl')")
            result = prolog_thread.query(consulta)
            return result


def update_properties(selected_class):
    consulta_propiedades = f"propiedadesc({selected_class}, Propiedades)"
    propiedades_result = query_swi_prolog(consulta_propiedades)

    properties_listbox.delete(0, tk.END)

    if propiedades_result:
        if 'Propiedades' in propiedades_result[0] and propiedades_result[0]['Propiedades']:
            propiedades = propiedades_result[0]['Propiedades']
            for propiedad in propiedades:
                propiedad_str = f"{propiedad[0].replace('_', ' ')}({propiedad[1].replace('_', ' ')})" if isinstance(propiedad, tuple) else str(propiedad).replace('_', ' ')
                properties_listbox.insert(tk.END, propiedad_str)



def es_hoja(selected_class):
    consulta_es_hoja = f"es_hoja({selected_class})"
    es_hoja_result = query_swi_prolog(consulta_es_hoja)
    return es_hoja_result and es_hoja_result[0].get('Result', False)


def on_class_selected(event):
    selection = event.widget.curselection()
    if selection:
        selected_class = event.widget.get(selection[0])
        update_properties(selected_class)
        update_superclasses(selected_class)


def update_superclasses(selected_class):
    consulta_superclases = f"superclases_de({selected_class}, Superclases)"
    superclases_result = query_swi_prolog(consulta_superclases)

    superclass_listbox.delete(0, tk.END)

    if superclases_result and 'Superclases' in superclases_result[0]:
        superclases = superclases_result[0]['Superclases']
        for superclase in superclases:
            superclass_listbox.insert(tk.END, superclase)


def expand_class(selected_class):
    consulta_subclases_directas = f"findall(C, frame(C, subclase_de({selected_class}), _), Subclases)"
    subclases_result = query_swi_prolog(consulta_subclases_directas)

    class_listbox.delete(0, tk.END)

    if subclases_result and 'Subclases' in subclases_result[0]:
        subclases = subclases_result[0]['Subclases']
        for subclase in subclases:
            class_listbox.insert(tk.END, subclase)

        superclass_listbox.insert(tk.END, selected_class)

        if subclases:
            update_properties(subclases[0])
        else:
            properties_listbox.delete(0, tk.END)


def on_class_double_clicked(event):
    selection = event.widget.curselection()
    if selection:
        selected_class = event.widget.get(selection[0])

        if es_hoja(selected_class):
            messagebox.showinfo("Información", f"{selected_class} es una hoja, no se puede expandir")
            return

        expand_class(selected_class)


def on_superclass_double_clicked(event):
    selection = event.widget.curselection()
    if selection:
        selected_superclass = event.widget.get(selection[0])
        expand_class(selected_superclass)
        update_superclasses(selected_superclass)


root = tk.Tk()
root.title("Taxonomía")

left_frame = tk.Frame(root)
left_frame.pack(side='left', padx=10, pady=10)

right_frame = tk.Frame(root)
right_frame.pack(side='right', padx=10, pady=10)

class_label = tk.Label(left_frame, text='Clases')
class_label.pack()

class_listbox = tk.Listbox(left_frame, width=20, height=10)
class_listbox.pack()
class_listbox.bind('<<ListboxSelect>>', on_class_selected)
class_listbox.bind('<Double-1>', on_class_double_clicked)
class_listbox.insert(tk.END, 'animalia')

superclass_label = tk.Label(left_frame, text='Es subclase de:')
superclass_label.pack()

superclass_listbox = tk.Listbox(left_frame, width=20, height=6)
superclass_listbox.pack()
superclass_listbox.bind('<Double-1>', on_superclass_double_clicked)

properties_label = tk.Label(right_frame, text='Propiedades')
properties_label.pack()

properties_listbox = tk.Listbox(right_frame, width=50, height=10)
properties_listbox.pack()

root.mainloop()