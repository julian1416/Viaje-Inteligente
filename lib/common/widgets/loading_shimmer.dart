// lib/common/widgets/loading_shimmer.dart

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart'; 

class LoadingShimmer extends StatelessWidget {
  final double? height; 
  final int count;      
  final bool isHorizontal; 

  const LoadingShimmer({
    super.key,
    this.height, 
    this.count = 1, 
    this.isHorizontal = false,
  });

  @override
  Widget build(BuildContext context) {
    // Si no se especifica una altura, usa un valor predeterminado razonable
    final double defaultHeight = height ?? (isHorizontal ? 200 : 150);
    final double defaultWidth = isHorizontal ? 220 : double.infinity; // Ancho para shimmer horizontal

    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!, // Color base del shimmer
      highlightColor: Colors.grey[100]!, // Color del "brillo"
      child: isHorizontal
          ? SizedBox(
              height: defaultHeight,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: count,
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.only(right: 15.0),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                    elevation: 0, // No queremos elevación en el shimmer
                    child: Container(
                      width: defaultWidth, // Ancho fijo para cada tarjeta de shimmer
                      height: defaultHeight,
                      // Puedes añadir más estructura interna aquí si el shimmer debe parecerse más a la tarjeta real
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container( // Placeholder de imagen
                            width: defaultWidth,
                            height: defaultHeight * 0.55, // Ejemplo: 55% de la altura para la imagen
                            color: Colors.white,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(width: defaultWidth * 0.7, height: 16, color: Colors.white), // Placeholder de texto
                                const SizedBox(height: 8),
                                Container(width: defaultWidth * 0.5, height: 14, color: Colors.white), // Placeholder de texto
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            )
          : Column( // Si no es horizontal, solo un shimmer vertical
              children: List.generate(count, (index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                    elevation: 0,
                    child: Container(
                      height: defaultHeight, // Altura del shimmer
                      width: defaultWidth,
                      color: Colors.white, // Color del contenedor del shimmer
                    ),
                  ),
                );
              }),
            ),
    );
  }
}