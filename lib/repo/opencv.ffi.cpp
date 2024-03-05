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
    transform(Image *src, cv::Point2f *srcCorners, cv::Size2f *destSize)
    {
        auto srcMat = cv::Mat(src->height, src->width, CV_8UC4, src->data);
        cv::Mat destMat;

        cv::Point2f destCorners[4] = {cv::Point2f{0, 0}, cv::Point2f{0, destSize->height - 1}, cv::Point2f(destSize->width - 1, destSize->height - 1), cv::Point2f{destSize->width - 1, 0}};
        auto perspectiveMat = cv::getPerspectiveTransform(srcCorners, destCorners);

        cv::warpPerspective(srcMat, destMat, perspectiveMat, *destSize, cv::INTER_LINEAR);

        struct Image dest;
        dest.width = destMat.size().width;
        dest.height = destMat.size().height;
        dest.channels = destMat.channels();
        dest.data = (uint8_t *)destMat.data;

        return dest;
    }

    __attribute__((visibility("default"))) __attribute__((used))
    const char* version() {
        return CV_VERSION;
    }
}