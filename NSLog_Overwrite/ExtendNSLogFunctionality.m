//
//  ExtendNSLogFunctionality.m
//
//
//  Created by Jannik Lorenz on 09.11.14.
//

#import "ExtendNSLogFunctionality.h"

#include <sys/time.h>

void ExtendNSLog(const char *file, int lineNumber, const char *functionName, NSString *format, ...)
{
    // Type to hold information about variable arguments.
    va_list ap;

    // Initialize a variable argument list.
    va_start (ap, format);

    // NSLog only adds a newline to the end of the NSLog format if
    // one is not already there.
    // Here we are utilizing this feature of NSLog()
    if (![format hasSuffix: @"\n"])
    {
        format = [format stringByAppendingString: @"\n"];
    }

    NSString *body = [[NSString alloc] initWithFormat:format arguments:ap];

    // End using variable argument list.
    va_end (ap);


    char* c_time_string = "";
    {
        char buffer[30];
        struct timeval tv;

        time_t curtime;

        gettimeofday(&tv, NULL);
        curtime=tv.tv_sec;

        strftime(buffer,30,"%T.",localtime(&curtime));

        char buf[15];
        snprintf(buf, sizeof buf, "%s%d", buffer, tv.tv_usec);
        c_time_string = buf;
    }





    NSString *fileName = [[NSString stringWithUTF8String:file] lastPathComponent];

    NSString *post = [NSString stringWithFormat:@"device=%@&time=%s&method=%s&file=%s&line=%d&message=%s", [[UIDevice currentDevice] name], c_time_string, functionName, [fileName UTF8String], lineNumber, [body UTF8String]];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%d",[postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"http://10.1.0.102:3000/"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    [[NSURLConnection alloc] initWithRequest:request delegate:nil];






    fprintf(stderr, "%s: (%s) (%s:%d) %s",c_time_string,
            functionName, [fileName UTF8String],
            lineNumber, [body UTF8String]);

}
