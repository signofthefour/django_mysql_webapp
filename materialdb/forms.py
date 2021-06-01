from django import forms

class AddIntersection(forms.Form):
    id = forms.IntegerField()
    long = forms.FloatField()
    lat = forms.FloatField()
