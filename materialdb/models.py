from django.db import models
from django.db.models.fields import FloatField

class IntersectionManager(models.Manager):
    def create_user(self, id, long, lat):
        intersection = self.model(id=id, long=long, lat=lat)
        intersection.save(using=self._db)
        return intersection
    def save(self):
        self.filter

class Intersection(models.Model):
    id = models.AutoField(primary_key=True)
    long = models.FloatField()
    lat = models.FloatField()
    objects = IntersectionManager()

    def __str__(self):
        return ("%s, %s, %s", self.id, self.long, self.lat)

    def save(self, *args, **kwargs):
        super(Intersection, self).save(*args, **kwargs)
    
