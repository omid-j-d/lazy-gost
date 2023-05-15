# lazy-gost
اسکریپت lazy gost برای ایجاد سریع تانلینگ گاست با متد forwqrd + tls

قدم اول

دانلود فایل های مورد نیاز و تنظیمات اولیه :

apt install git -y
https://github.com/omid-j-d/lazy-gost
cp /root/lazy-gost/gost.sh /root/

chmod +x gost.sh


این دستور فقط در سرور خارج اجرا شود 

cp /root/lazy-gost/ssl.sh /root/
chmod +x ssl.sh


قدم دوم

دریافت گواهی ssl ( این دستور را فقط در سرور خارج اجرا کنید)نرحله 

bash ssl.sh

قدم سوم 

نصب gost بر روی هر دو سرور خارج و ایران




