![metra_logo_Modern](https://user-images.githubusercontent.com/73336909/149669809-2b0052ef-91ba-4ee7-af22-7e2d78ddd380.png)


<br /><br /><p align=center>
<a href="https://opensource.org/licenses/MIT">
<img src="https://badges.gitter.im/METRA-IT/community.svg">
</a>
<a href="https://github.com/Mehrankhan-METRA-RGB/cross_scroll/actions">
<img src="https://img.shields.io/badge/License-MIT-yellow.svg">
</a>
<a href="https://github.com/Mehrankhan-METRA-RGB/cross_scroll/actions">
<img src="https://github.com/EdsonBueno/infinite_scroll_pagination/workflows/build/badge.svg">
</a>
<a href="https://github.com/Mehrankhan-METRA-RGB/cross_scroll">
<img src="https://img.shields.io/badge/platform-flutter-ff69b4.svg" >
</a><a href="https://github.com/Mehrankhan-METRA-RGB/cross_scroll">
<img src="https://img.shields.io/static/v1.svg?label=Pub&message=0.0.2&color=blue" >
</a>
<br /><br />
<a href="https://www.linkedin.com/in/mehran-ullah-742035153/">
<img src="https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white" >
</a>
<a href="#">
<img src="https://img.shields.io/badge/WhatsApp-25D366?style=for-the-badge&logo=whatsapp&logoColor=white" >
</a>
<a href="https://mailto:m.jan9396@gmail.com">
<img src="https://img.shields.io/badge/Gmail-D14836?style=for-the-badge&logo=gmail&logoColor=white" >
</a></p>


---


# Package: Cross Scroll
A CrossScroll is a flutter Package that permits it’s child views to be scrolled vertically and Horizontally. This is important because in many cases you need content to be scrolled on both side.




### List of features
- The vertical scrollbar wil never  hides when the scrolling on horizontal axis and vice versa. The scrollBar never hides with scrolling on any directions.
- Support track onClick scrolls.
- Support thumb Drag scrolls.
- Support All feature `SingleChildScrollView` have.







## Tested Platform

#### WEB
- MicroSoft Edge

![cross_scroll web test](https://user-images.githubusercontent.com/73336909/149651423-d1dc936f-cfc0-4581-bb79-19e1fc4ec533.gif)
<br />
<br />
- MacOS-Chrome
![mac-web-test](https://user-images.githubusercontent.com/73336909/153384605-351a569e-ddbe-452d-a256-81af2b1dbbe3.gif)



















#### Windows
- Windows 10

![cross_scroll window test](https://user-images.githubusercontent.com/73336909/149651492-2ce542a7-7343-4651-81b1-d3eccf3f9bda.gif)





#### Mobiles
- IOS 15.2

<br />
<img src="https://user-images.githubusercontent.com/73336909/152481771-df6529d9-b843-42b2-bafb-178e948f1941.gif" alt="IOS image" height="500" width="230">
<br /><br />

- Android 11
  
<br />
<img src="https://user-images.githubusercontent.com/73336909/152482303-1792aa66-d365-46aa-b414-e22a5ccd1754.gif" alt="Android image" height="500" width="230">
<br /><br />










## Getting started



## CrossScrollView
```dart
CrossScroll(
      child:///your child 
    )

```




#### Modify Thumb and Track
```dart
 CrossScrollBar crossScrollBar=CrossScrollBar(thumb: ScrollThumb.alwaysShow,
    track: ScrollTrack.show,
    thickness: 8,
    hoverThickness: 8,
    thumbRadius: Radius.elliptical(8, 8));
```












#### Scrolling Behaviours
```dart
 final CrossScrollStyle _crossScrollStyle =  CrossScrollStyle(
    physics: BouncingScrollPhysics(),
    keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.manual,
    padding:const EdgeInsets.symmetric(vertical: 2),
  );

```



## Additional information
Coming soon...

---