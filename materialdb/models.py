from django.db import models
from django.db.models.fields import FloatField

class PassengerManager(models.Manager):
    def create_passenger(self, id, ssn, job, sex, email, dob):
        passenger = self.model(passenger_id=id, ssn=ssn, job=job, sex=sex, email=email, dob=dob)
        passenger.save(using=self._db)
        return passenger

    def save(self):
        self.filter

class Passenger(models.Model):
    passenger_id = models.AutoField(primary_key=True)
    ssn = models.CharField(max_length=256)
    job = models.CharField(max_length=256)
    sex = models.CharField(max_length=5)
    email = models.CharField(max_length=256)
    dob = models.DateField()

    objects = PassengerManager()

    def __str__(self):
        return ("%s, %s, %s", self.id, self.long, self.lat)

    def save(self, *args, **kwargs):
        super(Passenger, self).save(*args, **kwargs)
    
