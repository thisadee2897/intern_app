# intern_app

//add image
![OHO-Task-Icon-Transparent](assets/icons/OHO-Task-Icon-Transparent.png)

Gen Model Script

```
dart run build_runner build --delete-conflicting-outputs
```


# 1. สร้าง release version ใหม่
./scripts/build-release.sh 1.0.6

# 2. Push tag ขึ้น GitHub
git push origin v1.0.6

# 3. GitHub Actions จะ build และสร้าง release อัตโนมัติ