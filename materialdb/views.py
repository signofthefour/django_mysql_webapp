from django.shortcuts import render, redirect
from django.views.generic import TemplateView, ListView
from django.template import RequestContext
from .models import Intersection
from materialdb.forms import AddIntersection


class dashboardView(ListView):
    template_name = 'dashboard.html'

    def get_queryset(self):
        return Intersection.objects.all()

class tableView(ListView):
    template_name = 'tables.html'

    def get_queryset(self):
        return Intersection.objects.all()

    def post(self, request):
        form = Intersection(request.POST or None)

        context = { 'form': form }
        if 'deleteEntry' in request.POST:
            id_num = request.POST['deleteEntry']
            Intersection.objects.filter(id=id_num).delete()

            return redirect('/')

        elif 'editEntry' in request.POST:

            values = request.POST['editEntry']
            values = values.split(',')
            request.session['id'] = values[0]
            request.session['long'] = values[1]
            request.session['lat'] = values[2]

            return redirect('/edit')

class addIntersectionView(TemplateView):
    template_name = 'addperson.html'

    def get(self, request):
        form = AddIntersection()
        return render(request, self.template_name, {'form':form})

    def post(self, request):
        form = AddIntersection(request.POST or None)

        context = { 'form': form }
        if form.is_valid():
            first_name = form.cleaned_data['first_name']
            context.update({'first_name': first_name})

            last_name = form.cleaned_data['last_name']
            context.update({'last_name': last_name})

            salary = form.cleaned_data['salary']
            context.update({'salary': salary})

            country = form.cleaned_data['country']
            context.update({'country': country})

            city = form.cleaned_data['city']
            context.update({'city': city})


            Intersection.objects.create_user(first_name, last_name, country, city, salary)
            return redirect('/')

        return render(request, self.template_name, context)

class editIntersectionView(TemplateView):
    template_name = 'editIntersection.html'

    def get(self, request):
        form = Intersection()
        return render(request, self.template_name, {'form':form})

    def post(self, request):
        form = Intersection(request.POST or None)
        context = { 'form': form }
        if form.is_valid():

            _id = request.POST['id']
            context.update({'id': _id})

            _long = form.cleaned_data['long']
            context.update({'long': _long})

            _lat = form.cleaned_data['lat']
            context.update({'lat': _lat})

            person = Intersection.objects.filter(id=_id).update(id=_id, long=_long, lat=_lat)

            return redirect('/')
        return render(request, self.template_name, context)