from django import forms
from django.forms.widgets import ChoiceWidget

class AddIntersection(forms.Form):
    id = forms.IntegerField()
    long = forms.FloatField()
    lat = forms.FloatField()

class AddTrip(forms.Form):
    trip_index = forms.CharField(label='Trip Index: ', max_length=100, required=True)

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

    