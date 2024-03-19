#include <iostream>
#include <vector>
#include <opencv2/opencv.hpp>
#include <string>

struct Image
{
    int width;
    int height;
    int channels;
    uint8_t *data;
};

extern "C"
{
    __attribute__((visibility("default"))) __attribute__((used))
    Image
    transform(Image *src, cv::Point2f *srcCorners, cv::Range *destRange, cv::Size2f *destSize)
    {   
        auto srcMat = cv::Mat(src->height, src->width, CV_8UC4, src->data)(destRange[1], destRange[0]).clone();
        cv::Mat destMat;

        cv::Point2f destCorners[4] = {cv::Point2f{0, 0}, cv::Point2f{destSize->width, 0}, cv::Point2f(destSize->width, destSize->height), cv::Point2f{0, destSize->height}};
        auto perspectiveMat = cv::getPerspectiveTransform(srcCorners, destCorners);

        cv::warpPerspective(srcMat, destMat, perspectiveMat, *destSize, cv::INTER_LINEAR);

        struct Image dest;
        dest.width = destMat.size().width;
        dest.height = destMat.size().height;
        dest.channels = destMat.channels();

        dest.data = new uint8_t[destMat.total()*destMat.elemSize()];
        std::memcpy(dest.data, destMat.data, destMat.total()*destMat.elemSize());
   
        return dest;
    }

    __attribute__((visibility("default"))) __attribute__((used))
    const char* version() {
        return CV_VERSION;
    }
}