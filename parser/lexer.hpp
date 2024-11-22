#pragma once

#include <cstdlib>
#include <FlexLexer.h>

namespace yy {

    class PLexer final : public yyFlexLexer {
        public:
            PLexer() = default;

            PLexer(const PLexer& rhs) = delete;
            PLexer& operator=(const PLexer& rhs) = delete;

            int yylex() override;
    };

}
