# prjctr-27-lambdas

```shell
chmod +x create_pillow_layer.sh
./create_pillow_layer.sh
terraform init
terraform apply
aws s3 cp image1.jpg s3://source-images-bucket-78123456
```

Then check the destination bucket for converted images:

```shell
aws s3 ls s3://converted-images-bucket-78123456 
```

Result:

```
2025-04-09 19:11:03   25657914 image1.bmp
2025-04-09 19:11:17    4206661 image1.gif
```
