from django.contrib.auth.decorators import login_required

class LoginRequiredMixmin(object):
    @classmethod
    def as_view(cls, **initkwargs):
        view = super(LoginRequiredMixmin, cls).as_view(**initkwargs)
        return login_required(view)