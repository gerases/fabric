%define name Fabric
%define version 1.14.0
%define unmangled_version 1.14.0
%define unmangled_version 1.14.0
%define release 1

Summary: Fabric is a simple, Pythonic tool for remote execution and deployment.
Name: %{name}
Version: %{version}
Release: %{release}
Source0: %{name}-%{unmangled_version}.tar.gz
License: UNKNOWN
Group: Development/Libraries
BuildRoot: %{_tmppath}/%{name}-%{version}-%{release}-buildroot
Prefix: %{_prefix}
BuildArch: noarch
Vendor: Jeff Forcier <jeff@bitprophet.org>
Packager: sgerasenko@conversant.com
Requires: python2-tqdm python2-setuptools
Requires: python2-paramiko python2-gnupg bash-completion
Url: http://fabfile.org

%description

To find out what's new in this version of Fabric, please see `the changelog
<http://fabfile.org/changelog.html>`_.

You can also install the `development version via ``pip install -e
git+https://github.com/fabric/fabric/#egg=fabric``.

----

Fabric is a Python (2.5-2.7) library and command-line tool for
streamlining the use of SSH for application deployment or systems
administration tasks.

It provides a basic suite of operations for executing local or remote shell
commands (normally or via ``sudo``) and uploading/downloading files, as well as
auxiliary functionality such as prompting the running user for input, or
aborting execution.
 
Typical use involves creating a Python module containing one or more functions,
then executing them via the ``fab`` command-line tool. Below is a small but
complete "fabfile" containing a single task:

.. code-block:: python

    from fabric.api import run

    def host_type():
        run('uname -s')

If you save the above as ``fabfile.py`` (the default module that
``fab`` loads), you can run the tasks defined in it on one or more
servers, like so::

    $ fab -H localhost,linuxbox host_type
    [localhost] run: uname -s
    [localhost] out: Darwin
    [linuxbox] run: uname -s
    [linuxbox] out: Linux

    Done.
    Disconnecting from localhost... done.
    Disconnecting from linuxbox... done.

In addition to use via the ``fab`` tool, Fabric's components may be imported
into other Python code, providing a Pythonic interface to the SSH protocol
suite at a higher level than that provided by e.g. the ``Paramiko`` library
(which Fabric itself uses.)


----

For more information, please see the Fabric website or execute ``fab --help``.


%prep
%setup -n %{name}-%{unmangled_version} -n %{name}-%{unmangled_version}

%build
python setup.py build

%install
python setup.py install --single-version-externally-managed -O1 --root=$RPM_BUILD_ROOT --record=INSTALLED_FILES
install -d $RPM_BUILD_ROOT/usr/bin
install -d $RPM_BUILD_ROOT/etc/bash_completion.d
install conversant/cnvr-fab $RPM_BUILD_ROOT/usr/bin/
install conversant/cnvr-fab-completion.bash $RPM_BUILD_ROOT/etc/bash_completion.d

%clean
rm -rf $RPM_BUILD_ROOT

%files -f INSTALLED_FILES
%defattr(-,root,root)
/usr/bin/cnvr-fab
/etc/bash_completion.d/cnvr-fab-completion.bash
