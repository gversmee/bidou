c = get_config()
c.Jupyterhub.admin_access = True
c.Authenticator.admin_users = {'greg'}
c.JupyterHub.authenticator_class = 'jupyterhub.auth.PAMAuthenticator'
c.JupyterHub.config_file = '/etc/jupyterhub/jupyterhub_config.py'
c.JupyterHub.cookie_secret_file = '/etc/jupyterhub/jupyterhub_cookie_secret'
c.LocalAuthenticator.create_system_users = True
c.Spawner.notebook_dir = '~'
c.JupyterHub.db_url = '/etc/jupyterhub/jupyterhub.sqlite'
from jupyter_client.localinterfaces import public_ips
c.JupyterHub.ip = public_ips()[0]
c.JupyterHub.port = 8000
c.JupyterHub.ssl_cert = '/srv/sslcert.pem'
c.JupyterHub.ssl_key = '/srv/sslkey.pem'
c.Spawner.cmd = ['jupyter-labhub']