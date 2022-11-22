import string
import random
import pandas as pd

def random_char(y):
    return ''. join(random. choice(string. ascii_letters) for x in range(y))

cuantos=random.randint(5,100) # de 5 a 100 filas
provincias=["Álava", "Albacete", "Alicante", "Almería", "Asturias", "Ávila", "Badajoz", "Barcelona", "Burgos", "Cáceres", "Cádiz", "Cantabria", "Castellón", "Ciudad Real", "Córdoba", "Cuenca", "Gerona", "Granada", "Guadalajara", "Guipúzcoa", "Huelva", "Huesca", "Islas Baleares", "Jaén", "La Coruña", "La Rioja", "Las Palmas", "León", "Lérida", "Lugo", "Madrid", "Málaga", "Murcia", "Navarra", "Orense", "Palencia", "Pontevedra", "Salamanca", "Santa Cruz de Tenerife", "Segovia", "Sevilla", "Soria", "Tarragona", "Teruel", "Toledo", "Valencia", "Valladolid", "Vizcaya", "Zamora", "Zaragoza"];
nombre = []
apellidos = []
provincia = []
edad = []
for i in range(cuantos):
    nombre.append(random_char( random.randint(4,10)))
    apellidos.append(random_char(random.randint(6,25)))
    provincia.append(random.choice(provincias))
    edad.append(random.randint(0,110))

tabla = pd.DataFrame({"nombre":nombre,"apellidos":apellidos,"provincia":provincia,"edad":edad})
tabla