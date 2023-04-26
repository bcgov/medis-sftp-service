# medis-sftp-service

Work in Progress.
OpenShift job based on the image of Apline Linux with sftp client added to it. The job runs upload.sh script that gets injected via ConfigMap.

Build the image.
1. Create build configuration in tools project.
oc process -f app.bc.yaml -p SOURCE_REPO_URL="https://github.com/bcgov/medis-sftp-service.git" | oc apply -f -
2. Start the build
oc start-build medis-sftp-app
Note that that Github hooks are not implemented yet.

Configure runtime.
1. Create all nessesary config maps and secrets

oc process -f app.cm.yaml -p P_SFTP_CONNECTION="your_user@your_sftp_server" -p P_SFTP_UPLOAD_DIR="/your_upload_dir" -p P_ARCHIVE_RETENTION_DAYS="60" | oc apply -f -

This will create the following config maps:
- medis-sftp-bin to hold shells scripts that will be mount to the pod that runs the job
- medis-sftp-config-files - other files to be mount on the pod. So far we just carry known_hosts file
- medis-sftp-config-env - to hold parameters that will be available in the pod environment

Additionally the is one secret to be created:
secret name: medis-sftp-secret, key name: medis-etl-ssh-key. The key contains ssh private key used to connect to remote SFTP server. Gets mount as a file on the pod running sftp job

Kick new job to upload the files to remote SFTP server.

oc process -f app.job.yaml -p TS=`date +%Y%m%d%H%M%S` | oc apply -f -


