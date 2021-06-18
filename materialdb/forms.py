from django.db import router
from materialdb.models import Route, Stopping_point, Trip
from django import forms
from django.forms.widgets import ChoiceWidget

class AddIntersection(forms.Form):
    id = forms.IntegerField()
    long = forms.FloatField()
    lat = forms.FloatField()

class AddTrip(forms.Form):
    route_id = forms.CharField(label='Route Index ', max_length=100, required=False)
    trip_index = forms.CharField(label='Trip Index: ', max_length=100, required=True)

    def clean(self):
        cleaned_data = super(forms.Form, self).clean()
        trip_idx_list = [(trip['trip_index'], trip['route_id'] )for trip in list(Trip.objects.all().values())]
        trip_index = cleaned_data.get("trip_index")
        route_id = cleaned_data.get("route_id")
        print(trip_idx_list)
        for trip in trip_idx_list:
            if str(trip[0]) == str(trip_index) and str(trip[1]) == str(route_id):
                raise forms.ValidationError("Trip index already exist, suggest index: {}".format(max([trip[0] for trip in trip_idx_list]) + 1))

        return cleaned_data
        


class AddRoute(forms.Form):
    # forms.ChoiceField(label='Type', choices=['B', 'T'])
    route_id_type = forms.ChoiceField(label='Route Type: ', choices=[('B', 'Bus'), ('T', 'Train')], widget=forms.Select)
    route_id_num = forms.CharField(label='Number ID: ', max_length=3)
    train_name = forms.CharField(label='Name of train route (if type is Train) ', max_length=100, required=False)
    train_unit_price = forms.IntegerField(label='Unit price of train route (if type is Train): ', required=False)
    train_route_id = forms.CharField(label='Train route ID  (if type is Train): ', max_length=1, required=False)

    def clean(self):
        cleaned_data = super(forms.Form, self).clean()
        is_train = 'T' in cleaned_data.get("route_id_type")
        train_name = cleaned_data.get("train_name")
        train_unit_price = cleaned_data.get("train_unit_price")
        train_route_id = cleaned_data.get("train_route_id")
        if is_train:
            if train_name is None:
                raise forms.ValidationError("Train name field id required")
            if train_unit_price is None:
                raise forms.ValidationError("Train unit price field is required")
            if train_route_id is None:
                raise forms.ValidationError("Train route id is required")
            elif train_route_id.islower():
                raise forms.ValidationError("Train route id must be UPPERCASE ALPHABET")

        return cleaned_data

stopping_point = list(Stopping_point.objects.all().values())

STOPPING_LIST = [(stop['id'], str(stop['name']).upper() + ' at ' + str(stop['address']).upper() + " for " + ("TRAIN" if stop['type'] else "BUS")) for stop in stopping_point]

class AddVisit(forms.Form):
    route_id = forms.CharField(label='Route ID: ', max_length=4)
    trip_index = forms.IntegerField(label='Trip Index: ')
    stopping_point_id = forms.ChoiceField(label='Stopping point', choices=STOPPING_LIST, required=True)
    index = forms.IntegerField(label='At Index', required=True)
    arrival_time = forms.TimeField(label='Arrive at', required=True )
    departure_time = forms.TimeField(label='Depart at', required=True)

    def clean(self):
        cleaned_data = super(forms.Form, self).clean()
        route_id = cleaned_data.get("route_id")
        trip_index = cleaned_data.get("trip_index")
        stopping_point = cleaned_data.get("stopping_point_id")
        arrival_time = cleaned_data.get("arrival_time")
        departure_time = cleaned_data.get("departure_time")

        if not stopping_point:
            raise forms.ValidationError("Please choose stopping_point")
        if not arrival_time:
            raise forms.ValidationError("Please fill arrival time")
        if not departure_time:
            raise forms.ValidationError("Please fill departure time")

        return cleaned_data
    