#include <iostream>

#include <boost/program_options.hpp>

namespace po = boost::program_options;

int main(int argc, char** argv) {
  try {
    po::options_description desc("Options");
    desc.add_options()
      ("help,h", "Print help message")
      ("source", po::value<std::string>(), "source file");

    po::positional_options_description posDesc;
    posDesc.add("source", -1);

    po::variables_map varMap;
    po::store(po::parse_command_line(argc, argv, desc), varMap);
    po::notify(varMap);

    if (varMap.count("help")) {
      std::cout << desc << "\n";
      return 0;
    }
  } catch (const po::error& ex) {
    std::cerr << ex.what() << "\n";
  }

  return 0;
}