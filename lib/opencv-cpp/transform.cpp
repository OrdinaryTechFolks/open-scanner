#include <iostream>
#include <vector>
#include <opencv2/opencv.hpp>
#include <string>

struct Image
{
    int width;
    int height;
    uint8_t *data;
};

extern "C" {
    // Attributes to prevent 'unused' function from being removed and to make it visible
    __attribute__((visibility("default"))) __attribute__((used))
    Image transform(Image *src) {
        std::cout << src->width;
        std::cout << src->height;
        std::cout << src->data;
        std::cout << *src->data;

        struct Image dest; 
        // dest.width = 2;
        dest.width = src->width;
        // dest.height = 3;
        dest.height = src->height;
        // dest.data = new uint8_t[6]{2, 5, 32, 3, 5, 8};
        dest.data = src->data;

        return dest;
    }
}