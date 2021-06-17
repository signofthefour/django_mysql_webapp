from django.shortcuts import render, redirect
from django.views.generic import TemplateView, ListView
from django.template import RequestContext
from .models import Passenger
from materialdb.forms import AddIntersection


class DashboardView(ListView):
    template_name = 'dashboard.html'

    def get_queryset(self):
        return Passenger.objects.all()

class RouteTableView(ListView):
    template_name = './user/table.html'

    def get_queryset(self):
        return Passenger.objects.all()

    def post(self, request):
        form = Passenger(request.POST or None)

        context = { 'form': form }

        if 'deleteEntry' in request.POST:
            id_num = request.POST['deleteEntry']
            Passenger.objects.filter(passenger_id=id_num).delete()

            return redirect('/user/tableview')

        elif 'editEntry' in request.POST:

            values = request.POST['editEntry']
            values = values.split(',')
            request.session['id'] = values[0]
            request.session['ssn'] = values[1]
            request.session['job'] = values[2]
            request.session['sex'] = values[3]
            request.session['email'] = values[4]
            request.session['dob'] = values[5]


            return redirect('route/edit')

class addIntersectionView(TemplateView):
    template_name = 'addperson.html'

    def get(self, request):
        form = AddIntersection()
        return render(request, self.template_name, {'form':form})

    def post(self, request):
        form = AddIntersection(request.POST or None)

        context = { 'form': form }
        if form.is_valid():
            id = form.cleaned_data['id']
            context.update({'id': id})

            ssn = form.cleaned_data['ssn']
            context.update({'ssn': ssn})

            job = form.cleaned_data['job']
            context.update({'job': job})

            sex = form.cleaned_data['sex']
            context.update({'sex': sex})

            email = form.cleaned_data['email']
            context.update({'email': email})

            dob = form.cleaned_data['dob']
            context.update({'dob': dob})

            Passenger.objects.create_user(passenger_id=id, ssn=ssn, job=job, sex=sex, email=email, dob=dob)
            return redirect('/route/table')

        return render(request, self.template_name, context)

class EditIntersectionView(TemplateView):
    template_name = './route/edit.html'

    def get(self, request):
        passenger = Passenger()
        return render(request, self.template_name, {'form':[passenger]})

    def post(self, request):
        form = Passenger(request.POST or None)
        context = { 'form': form }
        if form.is_valid():

            id = form.cleaned_data['id']
            context.update({'id': id})

            ssn = form.cleaned_data['ssn']
            context.update({'ssn': ssn})

            job = form.cleaned_data['job']
            context.update({'job': job})

            sex = form.cleaned_data['sex']
            context.update({'sex': sex})

            email = form.cleaned_data['email']
            context.update({'email': email})

            dob = form.cleaned_data['dob']
            context.update({'dob': dob})

            passenger= Passenger.objects.create_user(passenger_id=id, ssn=ssn, job=job, sex=sex, email=email, dob=dob)

            return redirect('/route/tableview')
        return render(request, self.template_name, context)