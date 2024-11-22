#pragma once

#include <unordered_map>

#include "inode.hpp"

namespace ast {

    struct SymtabItem {
        IntT value;
    };

    using Symtab = std::unordered_map<std::string, SymtabItem>;
    using SymtabIt = Symtab::iterator;

}
