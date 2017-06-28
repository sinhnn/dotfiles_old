/*
 * Project name   :
 * File name      : display4videos.cpp
 * Created date   : Mon 12 Jun 2017 01:02:49 PM +07
 * Author         : Ngoc-Sinh Nguyen
 * Last modified  : Mon 12 Jun 2017 01:02:49 PM +07
 * Desc           :
 */

#include <iostream>
#include <fstream>
#include <vector>

using namespace std;
#define URL_MAXSIZE 200
#define MAX_URLS	16


#define ERR	-1

struct info_t {
	/* data */
	vector <string> urls;
} /* optional variable list */;


int read_config_file( char *ifile, struct info_t *info)
{
	ifstream iF;
	int numb = 0;

	iF.open(ifile);
	if (iF.good()) {
		char url[URL_MAXSIZE];

		while(numb < MAX_URLS && iF.getline(&url[0], URL_MAXSIZE) ){
			info->urls.push_back(url);	
			numb ++;
		}
	} else return ERR;

	for (vector<string>::iterator it = info->urls.begin() ; it != info->urls.end(); ++it)
	    std::cout << *it << endl;

	iF.close();
    return numb; // Number of arg
}


int main(int argc, char *argv[])
{
    struct info_t info;
	int status = read_config_file("config.txt", &info);
	if (!status) {
		cout << "Empty config.txt file" << endl;	
	}else if (status == ERR) {
		cout << "config.txt file: Not Found" << endl;
	}

    return 0;
}

