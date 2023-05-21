import 'package:flutter/material.dart';
import 'package:mobile_flutter/models/toko_provider/base_model.dart';
import 'package:mobile_flutter/models/toko_provider/toko_data.dart';
import 'package:mobile_flutter/utils/themes/custom_color.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:mobile_flutter/view/toko/screen/cari_menu.dart';
import 'package:mobile_flutter/view/toko/screen/detail_produk.dart';
import 'package:mobile_flutter/utils/widget/toko_widget/reusable_price.dart';
import 'package:mobile_flutter/view/toko/screen/kategori_produk.dart';
import 'package:auto_size_text/auto_size_text.dart';

class TokoScreen extends StatefulWidget {
  const TokoScreen({super.key});

  @override
  State<TokoScreen> createState() => _TokoScreenState();
}

class _TokoScreenState extends State<TokoScreen> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var textTheme = Theme.of(context).textTheme;
    return SafeArea(
      child: Scaffold(
          body: SizedBox(
        width: size.width,
        height: size.height,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.03, vertical: 5),
                child: SizedBox(
                  width: size.width,
                  height: size.height * 0.07,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ListAllProduk(allProducts: getAllProducts()),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: neutral[10],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(color: neutral[70]!),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.search, color: neutral[70]),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            "Cari Kebutuhan disini...",
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              /// Body Slider
              CarouselSlider(
                options: CarouselOptions(
                  height: size.height * 0.20,
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 5),
                  autoPlayAnimationDuration: const Duration(milliseconds: 800),
                  // Other configuration options...
                ),
                items: crousel.map((data) {
                  return GestureDetector(
                    child: card(data, textTheme, size),
                  );
                }).toList(),
              ),

              //select kategory
              Container(
                margin: const EdgeInsets.only(top: 2),
                width: size.width,
                height: size.height * 0.16,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: category.length,
                  itemBuilder: (ctx, index) {
                    Category current = category[index];
                    return Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: GestureDetector(
                        onTap: () {
                          List<BaseModel> products =
                              getProductsByCategory(current.name);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ListProduk(
                                category: current.name,
                                products: products,
                              ),
                            ),
                          );
                        },
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: primary[300],
                                shape: BoxShape.circle,
                              ),
                              child: CircleAvatar(
                                radius: 35,
                                backgroundColor: Colors.transparent,
                                child: Container(
                                  width: 40,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      image: AssetImage(current.imageUrl),
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: size.height * 0.008,
                            ),
                            Text(
                              current.name,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              /// Spesial Untukmu
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Spesial Untukmu",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ],
                ),
              ),

              /// Spesial Untukmu
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                width: size.width,
                height: size.height * 0.47,
                child: GridView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: mainList.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 6 / 8,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 15,
                    ),
                    itemBuilder: (context, index) {
                      BaseModel current = mainList[index];
                      return GestureDetector(
                        onTap: (() => Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) {
                                FocusManager.instance.primaryFocus?.unfocus();
                                return Details(
                                  data: current,
                                  isCameFromProduk: true,
                                );
                              }),
                            )),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 0),
                          child: Card(
                            margin: const EdgeInsets.all(0),
                            elevation: 10,
                            shadowColor: Colors.black26,
                            surfaceTintColor: Colors.transparent,
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            color: Colors.white,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage(current.imageUrl),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.topLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 10,
                                        horizontal: 10,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.38,
                                            child: AutoSizeText(
                                              current.name,
                                              overflow: TextOverflow.ellipsis,
                                              minFontSize: 14,
                                              maxLines: 2,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleSmall,
                                            ),
                                          ),
                                          SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.38,
                                              child: ReuseablePrice(
                                                price: current.price,
                                              )),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.38,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 5.0),
                                              child: AutoSizeText(
                                                "${current.review.toString()}RB dilihat",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall,
                                                maxLines: 1,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
              ),
            ],
          ),
        ),
      )),
    );
  }

  /// Page view Cards
  Widget card(Crousel data, TextTheme theme, Size size) {
    return Padding(
      padding: const EdgeInsets.only(top: 7.0),
      child: Column(
        children: [
          Container(
            height: size.height * 0.19, // Adjust the height of the container
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3),
              image: DecorationImage(
                image: AssetImage(data.imageUrl),
                fit: BoxFit.contain,
                alignment: Alignment.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
