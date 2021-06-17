# Web Database Management 

This is a web application for viewing, adding, deleting, and editing data on your mySQL database created with Django.

---

## Installtion

Ensure that you have installed pip (pip3) in your system (a package of python)

```bash
pip install -r requirements.txt
```

Change your DB information [hear](databasereach/settings.py) at DATABASE config (line 79 in init commit)

After installation, go to working directory and run:

```bash
python manage.py migrate
python manage.py runserver
```

Then visit http://localhost:8000 on your browser
test