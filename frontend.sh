#! /usr/bin/bash
COMPONENT=frontend
source common.sh

echo Installing NGINX
yum install nginx -y &>> ${LOG}
StatusCheck

DOWNLOAD

echo Clean old content
cd /usr/share/nginx/html &>> ${LOG} && rm -rf * &>> ${LOG}
StatusCheck

echo Extract Downloaded Content
unzip -o /tmp/frontend.zip &>> ${LOG} && mv frontend-main/static/* . &>> ${LOG} && mv frontend-main/localhost.conf /etc/nginx/default.d/roboshop.conf &>> ${LOG}
StatusCheck

echo Updating Nginx Configuration
sed -i -e '/catalogue/ s/localhost/catalogue-dev.roboshop.internal/' -e '/cart/ s/localhost/cart-dev.roboshop.internal/' -e '/user/ s/localhost/user-dev.roboshop.internal/' -e '/shipping/ s/localhost/shipping-dev.roboshop.internal/' -e '/payment/ s/localhost/payment-dev.roboshop.internal/' /etc/nginx/default.d/roboshop.conf
StatusCheck

echo start nginx service
systemctl enable nginx &>> ${LOG} && systemctl start nginx &>> ${LOG} && systemctl restart nginx &>> ${LOG}
StatusCheck
