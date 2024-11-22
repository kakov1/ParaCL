#pragma once

#include <memory>
#include <string>

namespace ast {

    using IntT = int;

    class INode;
    class IScope;

    using INodePtr = std::shared_ptr<INode>;
    using IScopePtr = std::shared_ptr<IScope>;

    class INode {
        public:
            virtual IntT calc() const = 0;
            virtual ~INode() {}
    };

    class IScope : public INode {
        public:
            virtual void push(const INodePtr& node) = 0;
            virtual IScopePtr parentScope() const = 0;
    };

    enum class BinOp {
        Plus,
        Minus,
        Mul,
        Div,
        Mod,
        Assign,

        Equal,
        IsNe,
        Less,
        LessEqual,
        Greater,
        GreaterEq,
    };

    enum class UnOp {
        kPlus,
        kMinus,
    };

    INodePtr makeValue(IntT val);
    INodePtr makeUnOp(const INodePtr& n, UnOp op);
    INodePtr makeBinOp(const INodePtr& left, BinOp op, const INodePtr& right);
    INodePtr makeWhile(const INodePtr& op, const INodePtr& sc);
    INodePtr makeIf(const INodePtr& op, const INodePtr& sc);
    INodePtr makeVar(const std::string& name);
    INodePtr makePrint(const INodePtr& n);
    INodePtr makeScan(const INodePtr& n);
    IScopePtr makeScope(const IScopePtr& par = nullptr);

    extern IScopePtr current_scope;

}
