from enum import unique
from logging import FATAL
from django.db import models
from django.db.models import constraints
from django.db.models.fields import AutoField, CharField, FloatField, related
from compositefk.fields import CompositeForeignKey

class PassengerManager(models.Manager):
    def create_passenger(self, id, ssn, job, sex, email, dob):
        passenger = self.model(passenger_id=id, ssn=ssn, job=job, sex=sex, email=email, dob=dob)
        passenger.save(using=self._db)
        return passenger

    def save(self):
        self.filter

class Passenger(models.Model):
    passenger_id = models.CharField(primary_key=True, max_length=256)
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
    
class Intersection(models.Model):
    id = models.CharField(primary_key=True, max_length=256)
    long = models.FloatField()
    lat = models.FloatField()

    def save(self, *args, **kwargs):
        super(Intersection, self).save(*args, **kwargs)

class Street(models.Model):
    id = models.CharField(primary_key=True, max_length=256)
    name = models.CharField(max_length=50)

    def save(self, *args, **kwargs):
        super(Street, self).save(*args, **kwargs)

class Distance(models.Model):
    street = models.ForeignKey(Street, to_field='id', on_delete=models.CASCADE, primary_key=True)
    first_int = models.ForeignKey(Intersection, to_field='id',on_delete=models.CASCADE, related_name='distance_first_int', primary_key=False)
    second_int = models.ForeignKey(Intersection, to_field='id', on_delete=models.CASCADE, related_name='distance_second_int', primary_key=False)

    length = models.FloatField()
    dist_index = models.IntegerField()

    class Meta:
        constraints = [
            models.UniqueConstraint(fields=["first_int_id", "second_int_id"], name='unique_distance')
        ]
    
    def save(self, *args, **kwargs):
        super(Distance, self).save(*args, **kwargs)

class Route(models.Model):
    route_id = models.CharField(primary_key=True, max_length=256)

    def __str__(self):
        return ("%s, %s, %s", self.route_id)

    def save(self, *args, **kwargs):
        super(Route, self).save(*args, **kwargs)

class Trip(models.Model):
    trip_index = models.CharField(max_length=256)
    route = models.ForeignKey(Route, to_field='route_id', on_delete=models.CASCADE, related_name='trip_route_id', primary_key=True)

    class Meta:
        unique_together = (("trip_index", "route_id"),)

    def save(self, *args, **kwargs):
        super(Trip, self).save(*args, **kwargs)

class Stopping_point(models.Model):
    id = models.CharField(primary_key=True, max_length=256)
    name = models.CharField(max_length=256)
    address = models.CharField(max_length=256)
    type = models.BooleanField()
    first_int_id = models.CharField(max_length=256)
    second_int_id = models.CharField(max_length=256)
    distance = CompositeForeignKey(Distance, on_delete=models.CASCADE, related_name='distance', to_fields={
        "first_int_id": "first_int_id",
        "second_int_id": "second_int_id"
    })

    def save(self, *args, **kwargs):
        super(Stopping_point, self).save(*args, **kwargs)

class Visit(models.Model):
    uid = AutoField(primary_key=True)
    trip_route_id = models.CharField(max_length=256)
    trip_index = models.CharField(max_length=256)
    stopping_point_id = models.CharField(max_length=256)
    visit_index = models.IntegerField()
    arrival_time = models.TimeField()
    departure_time = models.TimeField()

    distance = CompositeForeignKey(Trip, on_delete=models.CASCADE, related_name='trip', to_fields={
        "route_id": "trip_route_id",
        "trip_index": "trip_index"
    })


    def __str__(self):
        return "{} {} {} {} {} {}".format(self.trip_route_id, self.trip_index, self.stopping_point_id,
                                    self.visit_index, self.arrival_time, self.departure_time)
    

    def save(self, *args, **kwargs):
        super(Visit, self).save(*args, **kwargs)


class Bus_route(models.Model):
    bus_route_id = models.CharField(primary_key=True, max_length=100)
    route = models.ForeignKey(Route, to_field='route_id', on_delete=models.CASCADE)

    def save(self, *args, **kwargs):
        super(Bus_route, self).save(*args, **kwargs)

class Train_route(models.Model):
    train_route = models.CharField(primary_key=True, max_length=100)
    name = models.CharField(max_length=100)
    unit_price = models.FloatField()
    route = models.ForeignKey(Route, to_field='route_id', on_delete=models.CASCADE)

    def save(self, *args, **kwargs):
        super(Train_route, self).save(*args, **kwargs)
