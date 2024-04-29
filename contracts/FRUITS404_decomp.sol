// 0x4bca66f9282a2f7e6a3e66579a2a06183207fc4a

// Decompiled by library.dedaub.com
// 2024.02.12 20:58 UTC
// Compiled using the solidity compiler version 0.8.24


// Data structures and variables inferred from the use of storage instructions
uint256[] array_1; // STORAGE[0x1]
uint256[] array_2; // STORAGE[0x2]
uint256 _minted; // STORAGE[0x3]
mapping (uint256 => uint256) _balanceOf; // STORAGE[0x4]
mapping (uint256 => mapping (uint256 => uint256)) _allowance; // STORAGE[0x5]
mapping (uint256 => uint256) _getApproved; // STORAGE[0x6]
mapping (uint256 => mapping (uint256 => uint256)) _isApprovedForAll; // STORAGE[0x7]
mapping (uint256 => uint256) _ownerOf; // STORAGE[0x8]
mapping (uint256 => struct_1309) owner_9; // STORAGE[0x9]
mapping (uint256 => uint256) owner_a; // STORAGE[0xa]
mapping (uint256 => uint256) _whitelist; // STORAGE[0xb]
uint256[] array_c; // STORAGE[0xc]
uint256[] _tokenURI; // STORAGE[0xd]
uint256 _owner; // STORAGE[0x0] bytes 0 to 19


// Events
Approval(address, address, uint256);
Transfer(address, address, uint256);
OwnershipTransferred(address, address);
ApprovalForAll(address, address, bool);

function 0x141e(bytes varg0, bytes varg1) private { 
    require(msg.sender == _owner, Unauthorized());
    0x276e(varg0, varg1);
    return ;
}

function 0x1662() private { 
    v0 = 0x3546(array_2.length);
    v1 = new bytes[](v0);
    v2 = v3 = v1.data;
    v4 = 0x3546(array_2.length);
    if (!v4) {
        return v1, v5;
    } else if (31 < v4) {
        v6 = v7 = array_2.data;
        do {
            MEM[v2] = STORAGE[v6];
            v6 += 1;
            v2 += 32;
        } while (v3 + v4 <= v2);
        return v1, v5;
    } else {
        MEM[v3] = array_2.length >> 8 << 8;
        return v1, v5;
    }
}

function name() public payable { 
    v0, v1 = 0x551();
    v2 = new bytes[](v0.length);
    v3 = v4 = 0;
    while (v3 < v0.length) {
        v2[v3] = v0[v3];
        v3 = v3 + 32;
    }
    v2[v0.length] = 0;
    return v2;
}

function getApproved(uint256 tokenId) public payable { 
    require(4 + (msg.data.length - 4) - 4 >= 32);
    return address(_getApproved[tokenId]);
}

function approve(address spender, uint256 amount) public payable { 
    require(4 + (msg.data.length - 4) - 4 >= 64);
    v0 = v1 = amount <= _minted;
    if (amount <= _minted) {
        v0 = v2 = amount > 0;
    }
    if (!v0) {
        _allowance[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
    } else {
        v3 = v4 = msg.sender != address(_ownerOf[amount]);
        if (msg.sender != address(_ownerOf[amount])) {
            v3 = v5 = !uint8(_isApprovedForAll[address(address(address(_ownerOf[amount])))][address(address(msg.sender))]);
        }
        require(!v3, Unauthorized());
        _getApproved[amount] = spender | bytes12(_getApproved[amount]);
        emit Approval(address(_ownerOf[amount]), spender, amount);
    }
    return True;
}

function 0x2024() private { 
    v0 = 0x3546(_tokenURI.length);
    v1 = new bytes[](v0);
    v2 = v3 = v1.data;
    v4 = 0x3546(_tokenURI.length);
    if (!v4) {
        return v1, v5;
    } else if (31 < v4) {
        v6 = v7 = _tokenURI.data;
        do {
            MEM[v2] = STORAGE[v6];
            v6 += 1;
            v2 += 32;
        } while (v3 + v4 <= v2);
        return v1, v5;
    } else {
        MEM[v3] = _tokenURI.length >> 8 << 8;
        return v1, v5;
    }
}

function 0x20d0(bytes varg0) private { 
    require(msg.sender == _owner, Unauthorized());
    require(varg0.length <= uint64.max, Panic(65)); // failed memory allocation (too much memory)
    v0 = 0x3546(_tokenURI.length);
    if (v0 > 31) {
        v1 = v2 = _tokenURI.data;
        v1 = v3 = v2 + (varg0.length + 31 >> 5);
        while (v1 < v2 + (v0 + 31 >> 5)) {
            STORAGE[v1] = STORAGE[v1] & ~0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff | uint256(0);
            v1 = v1 + 1;
        }
    }
    v4 = v5 = 32;
    if (varg0.length > 31 == 1) {
        v6 = _tokenURI.data;
        v7 = v8 = 0;
        while (v7 < varg0.length & ~0x1f) {
            STORAGE[v6] = MEM[varg0 + v4];
            v6 = v6 + 1;
            v4 = v4 + 32;
            v7 = v7 + 32;
        }
        if (varg0.length & ~0x1f < varg0.length) {
            STORAGE[v6] = MEM[varg0 + v4] & ~(~0 >> ((varg0.length & 0x1f) << 3));
        }
        _tokenURI = (varg0.length << 1) + 1;
    } else {
        v9 = v10 = 0;
        if (varg0.length) {
            v9 = MEM[varg0.data];
        }
        _tokenURI = v9 & ~(~0 >> (varg0.length << 3)) | varg0.length << 1;
    }
    return ;
}

function 0x2191() private { 
    v0 = 0x3546(array_c.length);
    v1 = new bytes[](v0);
    v2 = v3 = v1.data;
    v4 = 0x3546(array_c.length);
    if (!v4) {
        return v1, v5;
    } else if (31 < v4) {
        v6 = v7 = array_c.data;
        do {
            MEM[v2] = STORAGE[v6];
            v6 += 1;
            v2 += 32;
        } while (v3 + v4 <= v2);
        return v1, v5;
    } else {
        MEM[v3] = array_c.length >> 8 << 8;
        return v1, v5;
    }
}

function totalSupply() public payable { 
    return 10 ** 22;
}

function 0x23a2() private { 
    v0 = _SafeExp(10, uint8(18), uint256.max);
    return v0;
}

function 0x23d5(uint256 varg0, address varg1, address varg2) private { 
    v0 = 0x23a2();
    v1 = _SafeSub(_balanceOf[varg2], varg0);
    _balanceOf[varg2] = v1;
    _balanceOf[varg1] = _balanceOf[varg1] + varg0;
    if (!uint8(_whitelist[address(address(varg2))])) {
        v2 = _SafeDiv(_balanceOf[varg2], v0);
        v3 = _SafeDiv(_balanceOf[varg2], v0);
        v4 = _SafeSub(v3, v2);
        v5 = v6 = 0;
        while (v5 < v4) {
            require(varg2 - address(0x0), InvalidSender());
            v7 = v8 = 0;
            if (owner_9[varg2].field0.length > v8) {
                v9 = _SafeSub(owner_9[varg2].field0.length, 1);
                require(v9 < owner_9[varg2].field0.length, Panic(50)); // access an out-of-bounds or negative index of bytesN array or slice
                v7 = v10 = owner_9[varg2].field0[v9];
            }
            if (v7 > 0) {
                v11 = varg2;
                require(owner_9[v11].field0.length, Panic(49)); // attemp to .pop an empty array
                owner_9[v11].field0[owner_9[v11].field0.length - 1] = 0;
                owner_9[v11].field0.length = owner_9[v11].field0.length - 1;
                owner_a[v7] = 0;
                _ownerOf[v7] = bytes12(_ownerOf[v7]);
                _getApproved[v7] = bytes12(_getApproved[v7]);
                emit Transfer(varg2, address(0x0), v7);
            }
            v5 += 1;
        }
    }
    v12 = v13 = !uint8(_whitelist[address(address(varg1))]);
    if (!bool(_whitelist[address(address(varg1))])) {
        v12 = v14 = !uint8(_whitelist[address(address(varg2))]);
    }
    if (v12) {
        v15 = _SafeDiv(_balanceOf[varg1], v0);
        v16 = _SafeDiv(_balanceOf[varg1], v0);
        v17 = _SafeSub(v16, v15);
        v18 = v19 = 0;
        while (v18 < v17) {
            require(varg1 - address(0x0), InvalidRecipient());
            _minted += 1;
            require(address(_ownerOf[_minted]) == address(0x0), AlreadyExists());
            _ownerOf[_minted] = varg1 | bytes12(_ownerOf[_minted]);
            v20 = varg1;
            owner_9[v20].field0.length = owner_9[v20].field0.length + 1;
            owner_9[v20].field0[owner_9[v20].field0.length + 1 - 1] = _minted;
            v21 = _SafeSub(owner_9[varg1].field0.length, 1);
            owner_a[_minted] = v21;
            emit Transfer(address(0x0), varg1, _minted);
            v18 += 1;
        }
    }
    emit 0xe59fdd36d0d223c0c7d996db7ad796880f45e1936cb0bb7ac102e7082e031487(varg2, varg1, varg0);
    return 1;
}

function setDataURI(string _dataURI) public payable { 
    require(4 + (msg.data.length - 4) - 4 >= 32);
    require(_dataURI <= uint64.max);
    require(4 + _dataURI + 31 < 4 + (msg.data.length - 4));
    require(_dataURI.length <= uint64.max, Panic(65)); // failed memory allocation (too much memory)
    v0 = new bytes[](_dataURI.length);
    require(!((v0 + ((_dataURI.length + 31 & ~0x1f) + 32 + 31 & ~0x1f) > uint64.max) | (v0 + ((_dataURI.length + 31 & ~0x1f) + 32 + 31 & ~0x1f) < v0)), Panic(65)); // failed memory allocation (too much memory)
    require(_dataURI.data + _dataURI.length <= 4 + (msg.data.length - 4));
    CALLDATACOPY(v0.data, _dataURI.data, _dataURI.length);
    v0[_dataURI.length] = 0;
    0x918(v0);
}

function transferFrom(address sender, address recipient, uint256 amount) public payable { 
    require(4 + (msg.data.length - 4) - 4 >= 96);
    0x9af(amount, recipient, sender);
}

function 0x276e(bytes varg0, bytes varg1) private { 
    require(varg1.length <= uint64.max, Panic(65)); // failed memory allocation (too much memory)
    v0 = 0x3546(array_1.length);
    if (v0 > 31) {
        v1 = v2 = array_1.data;
        v1 = v3 = v2 + (varg1.length + 31 >> 5);
        while (v1 < v2 + (v0 + 31 >> 5)) {
            STORAGE[v1] = STORAGE[v1] & ~0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff | uint256(0);
            v1 = v1 + 1;
        }
    }
    v4 = v5 = 32;
    if (varg1.length > 31 == 1) {
        v6 = array_1.data;
        v7 = v8 = 0;
        while (v7 < varg1.length & ~0x1f) {
            STORAGE[v6] = MEM[varg1 + v4];
            v6 = v6 + 1;
            v4 = v4 + 32;
            v7 = v7 + 32;
        }
        if (varg1.length & ~0x1f < varg1.length) {
            STORAGE[v6] = MEM[varg1 + v4] & ~(~0 >> ((varg1.length & 0x1f) << 3));
        }
        array_1 = (varg1.length << 1) + 1;
    } else {
        v9 = v10 = 0;
        if (varg1.length) {
            v9 = MEM[varg1.data];
        }
        array_1 = v9 & ~(~0 >> (varg1.length << 3)) | varg1.length << 1;
    }
    require(varg0.length <= uint64.max, Panic(65)); // failed memory allocation (too much memory)
    v11 = 0x3546(array_2.length);
    if (v11 > 31) {
        v12 = v13 = array_2.data;
        v12 = v14 = v13 + (varg0.length + 31 >> 5);
        while (v12 < v13 + (v11 + 31 >> 5)) {
            STORAGE[v12] = STORAGE[v12] & ~0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff | uint256(0);
            v12 = v12 + 1;
        }
    }
    v15 = v16 = 32;
    if (varg0.length > 31 == 1) {
        v17 = array_2.data;
        v18 = v19 = 0;
        while (v18 < varg0.length & ~0x1f) {
            STORAGE[v17] = MEM[varg0 + v15];
            v17 = v17 + 1;
            v15 = v15 + 32;
            v18 = v18 + 32;
        }
        if (varg0.length & ~0x1f < varg0.length) {
            STORAGE[v17] = MEM[varg0 + v15] & ~(~0 >> ((varg0.length & 0x1f) << 3));
        }
        array_2 = (varg0.length << 1) + 1;
    } else {
        v20 = v21 = 0;
        if (varg0.length) {
            v20 = MEM[varg0.data];
        }
        array_2 = v20 & ~(~0 >> (varg0.length << 3)) | varg0.length << 1;
    }
    return ;
}

function 0x2792(uint256 varg0) private { 
    v0 = v1 = 0;
    if (varg0 >= 10 ** 64) {
        require(10 ** 64, Panic(18)); // division by zero
        varg0 = v2 = varg0 / 10 ** 64;
        v0 = v3 = 64;
    }
    if (varg0 >= 10 ** 32) {
        require(10 ** 32, Panic(18)); // division by zero
        varg0 = v4 = varg0 / 10 ** 32;
        v0 = v5 = v0 + 32;
    }
    if (varg0 >= 10 ** 16) {
        require(10 ** 16, Panic(18)); // division by zero
        varg0 = v6 = varg0 / 10 ** 16;
        v0 = v7 = v0 + 16;
    }
    if (varg0 >= 10 ** 8) {
        require(10 ** 8, Panic(18)); // division by zero
        varg0 = v8 = varg0 / 10 ** 8;
        v0 = v9 = v0 + 8;
    }
    if (varg0 >= 10000) {
        require(10000, Panic(18)); // division by zero
        varg0 = v10 = varg0 / 10000;
        v0 = v11 = v0 + 4;
    }
    if (varg0 >= 100) {
        require(100, Panic(18)); // division by zero
        varg0 = v12 = varg0 / 100;
        v0 = v13 = v0 + 2;
    }
    if (varg0 >= 10) {
        v0 = v14 = v0 + 1;
    }
    v15 = v0 + 1;
    require(v15 <= uint64.max, Panic(65)); // failed memory allocation (too much memory)
    v16 = new bytes[](v15);
    if (v15) {
        CALLDATACOPY(v16.data, msg.data.length, v15);
    }
    v17 = v18 = v16 + (32 + v15);
    while (1) {
        v17 = v17 - 1;
        MEM8[v17] = (byte('0123456789abcdef', varg0 % 10)) & 0xFF;
        require(10, Panic(18)); // division by zero
        varg0 = varg0 / 10;
        if (varg0 - 0) {
            break;
        }
    }
    return v16;
}

function revokeOwnership() public payable { 
    require(msg.sender == _owner, Unauthorized());
    _owner = 0;
    emit OwnershipTransferred(msg.sender, address(0x0));
}

function decimals() public payable { 
    return uint8(18);
}

function safeTransferFrom(address from, address to, uint256 tokenId) public payable { 
    require(4 + (msg.data.length - 4) - 4 >= 96);
    0x9af(tokenId, to, from);
    v0 = v1 = to.code.size != 0;
    if (to.code.size != 0) {
        v2 = new uint256[](0);
        v3, /* bytes4 */ v4 = to.onERC721Received(msg.sender, from, tokenId, v2).gas(msg.gas);
        require(bool(v3), 0, RETURNDATASIZE()); // checks call status, propagates error data on error
        MEM[64] = MEM[64] + (RETURNDATASIZE() + 31 & ~0x1f);
        require(MEM[64] + RETURNDATASIZE() - MEM[64] >= 32);
        require(v4 == bytes4(v4));
        v0 = bytes4(v4) != bytes4(0x150b7a0200000000000000000000000000000000000000000000000000000000);
    }
    require(!v0, UnsafeRecipient());
}

function minted() public payable { 
    return _minted;
}

function setNameSymbol(string tokenName, string tokenSymbol) public payable { 
    require(4 + (msg.data.length - 4) - 4 >= 64);
    require(tokenName <= uint64.max);
    require(4 + tokenName + 31 < 4 + (msg.data.length - 4));
    require(tokenName.length <= uint64.max, Panic(65)); // failed memory allocation (too much memory)
    v0 = new bytes[](tokenName.length);
    require(!((v0 + ((tokenName.length + 31 & ~0x1f) + 32 + 31 & ~0x1f) > uint64.max) | (v0 + ((tokenName.length + 31 & ~0x1f) + 32 + 31 & ~0x1f) < v0)), Panic(65)); // failed memory allocation (too much memory)
    require(tokenName.data + tokenName.length <= 4 + (msg.data.length - 4));
    CALLDATACOPY(v0.data, tokenName.data, tokenName.length);
    v0[tokenName.length] = 0;
    require(tokenSymbol <= uint64.max);
    require(4 + tokenSymbol + 31 < 4 + (msg.data.length - 4));
    require(tokenSymbol.length <= uint64.max, Panic(65)); // failed memory allocation (too much memory)
    v1 = new bytes[](tokenSymbol.length);
    require(!((v1 + ((tokenSymbol.length + 31 & ~0x1f) + 32 + 31 & ~0x1f) > uint64.max) | (v1 + ((tokenSymbol.length + 31 & ~0x1f) + 32 + 31 & ~0x1f) < v1)), Panic(65)); // failed memory allocation (too much memory)
    require(tokenSymbol.data + tokenSymbol.length <= 4 + (msg.data.length - 4));
    CALLDATACOPY(v1.data, tokenSymbol.data, tokenSymbol.length);
    v1[tokenSymbol.length] = 0;
    0x141e(v1, v0);
}

function setWhitelist(address _account, bool _whitelist) public payable { 
    require(4 + (msg.data.length - 4) - 4 >= 64);
    require(msg.sender == _owner, Unauthorized());
    _whitelist[_account] = _whitelist | bytes31(_whitelist[address(address(_account))]);
}

function ownerOf(uint256 tokenId) public payable { 
    require(4 + (msg.data.length - 4) - 4 >= 32);
    require(address(_ownerOf[tokenId]) - address(0x0), NotFound());
    return address(_ownerOf[tokenId]);
}

function balanceOf(address account) public payable { 
    require(4 + (msg.data.length - 4) - 4 >= 32);
    return _balanceOf[account];
}

function 0x3546(uint256 varg0) private { 
    v0 = v1 = varg0 >> 1;
    if (!(varg0 & 0x1)) {
        v0 = v2 = v1 & 0x7f;
    }
    require((varg0 & 0x1) - (v0 < 32), Panic(34)); // access to incorrectly encoded storage byte array
    return v0;
}

function owner() public payable { 
    return _owner;
}

function _SafeSub(uint256 varg0, uint256 varg1) private { 
    require(varg0 - varg1 <= varg0, Panic(17)); // arithmetic overflow or underflow
    return varg0 - varg1;
}

function symbol() public payable { 
    v0, v1 = 0x1662();
    v2 = new bytes[](v0.length);
    v3 = v4 = 0;
    while (v3 < v0.length) {
        v2[v3] = v0[v3];
        v3 = v3 + 32;
    }
    v2[v0.length] = 0;
    return v2;
}

function 0x3a19(uint256 varg0, uint256 varg1) private { 
    v0 = 0x3546(STORAGE[varg0]);
    if (STORAGE[varg0] & 0x1 == 0) {
        MEM[varg1] = bytes31(STORAGE[varg0]);
        return varg1 + v0 * bool(v0);
    } else if (STORAGE[varg0] & 0x1 == 1) {
        v1 = v2 = 0;
        while (v1 < v0) {
            MEM[varg1 + v1] = STORAGE[v3];
            v3 = v3 + 1;
            v1 = v1 + 32;
        }
        return varg1 + v0;
    } else {
        return 0;
    }
}

function whitelist(address varg0) public payable { 
    require(4 + (msg.data.length - 4) - 4 >= 32);
    return bool(_whitelist[varg0]);
}

function _SafeExp(uint256 varg0, uint256 varg1, uint256 varg2) private { 
    if (varg1) {
        if (varg0) {
            if (varg0 == 1) {
                return 1;
            } else if (varg0 == 2) {
                require(varg1 <= uint8.max, Panic(17)); // arithmetic overflow or underflow
                require(2 ** varg1 <= varg2, Panic(17)); // arithmetic overflow or underflow
                return 2 ** varg1;
            } else if (!((varg0 < 11) & (varg1 < 78) | (varg0 < 307) & (varg1 < 32))) {
                v0 = v1 = 1;
                while (varg1 > 1) {
                    require(varg0 <= varg2 / varg0, Panic(17)); // arithmetic overflow or underflow
                    if (varg1 & 0x1) {
                        v0 = v0 * varg0;
                    }
                    varg0 *= varg0;
                    varg1 = varg1 >> 1;
                }
                require(v0 <= varg2 / varg0, Panic(17)); // arithmetic overflow or underflow
                return v0 * varg0;
            } else {
                require(varg0 ** varg1 <= varg2, Panic(17)); // arithmetic overflow or underflow
                return varg0 ** varg1;
            }
        } else {
            return 0;
        }
    } else {
        return 1;
    }
}

function setApprovalForAll(address operator, bool approved) public payable { 
    require(4 + (msg.data.length - 4) - 4 >= 64);
    _isApprovedForAll[msg.sender][operator] = approved | bytes31(_isApprovedForAll[address(address(msg.sender))][address(address(operator))]);
    emit ApprovalForAll(msg.sender, operator, approved);
}

function _SafeDiv(uint256 varg0, uint256 varg1) private { 
    require(varg1, Panic(18)); // division by zero
    return varg0 / varg1;
}

function function_selector() public payable { 
    revert();
}

function transfer(address recipient, uint256 amount) public payable { 
    require(4 + (msg.data.length - 4) - 4 >= 64);
    v0 = 0x23d5(amount, recipient, msg.sender);
    return bool(v0);
}

function safeTransferFrom(address from, address to, uint256 tokenId, bytes _data) public payable { 
    require(4 + (msg.data.length - 4) - 4 >= 128);
    require(_data <= uint64.max);
    require(4 + _data + 31 < 4 + (msg.data.length - 4));
    require(_data.length <= uint64.max);
    require(_data.data + _data.length <= 4 + (msg.data.length - 4));
    0x9af(tokenId, to, from);
    v0 = v1 = to.code.size != 0;
    if (to.code.size != 0) {
        v2 = new bytes[](_data.length);
        CALLDATACOPY(v2.data, _data.data, _data.length);
        v2[_data.length] = 0;
        v3, /* bytes4 */ v4 = to.onERC721Received(msg.sender, from, tokenId, v2).gas(msg.gas);
        require(bool(v3), 0, RETURNDATASIZE()); // checks call status, propagates error data on error
        MEM[64] = MEM[64] + (RETURNDATASIZE() + 31 & ~0x1f);
        require(MEM[64] + RETURNDATASIZE() - MEM[64] >= 32);
        require(v4 == bytes4(v4));
        v0 = bytes4(v4) != bytes4(0x150b7a0200000000000000000000000000000000000000000000000000000000);
    }
    require(!v0, UnsafeRecipient());
}

function tokenURI(uint256 tokenId) public payable { 
    require(4 + (msg.data.length - 4) - 4 >= 32);
    v0 = 0x3546(_tokenURI.length);
    if (v0 <= 0) {
        v1 = v2 = 96;
        if (uint8(keccak256(tokenId) >> 248) > 76) {
            if (uint8(keccak256(tokenId) >> 248) > 139) {
                if (uint8(keccak256(tokenId) >> 248) > 190) {
                    if (uint8(keccak256(tokenId) >> 248) > 215) {
                        if (uint8(keccak256(tokenId) >> 248) > 232) {
                            if (uint8(keccak256(tokenId) >> 248) > 243) {
                                if (uint8(keccak256(tokenId) >> 248) > 249) {
                                    if (uint8(keccak256(tokenId) >> 248) > 251) {
                                        if (uint8(keccak256(tokenId) >> 248) > 254) {
                                            if (uint8(keccak256(tokenId) >> 248) <= uint8.max) {
                                                v1 = v3 = '10.jpg';
                                                v1 = v4 = 'Orange';
                                            }
                                        } else {
                                            v1 = v5 = '9.jpg';
                                            v1 = v6 = 'Dragonfruit';
                                        }
                                    } else {
                                        v1 = v7 = '8.jpg';
                                        v1 = v8 = 'Watermelon';
                                    }
                                } else {
                                    v1 = v9 = '7.jpg';
                                    v1 = v10 = 'Pineapple';
                                }
                            } else {
                                v1 = v11 = '6.jpg';
                                v1 = v12 = 'Cherry';
                            }
                        } else {
                            v1 = v13 = '5.jpg';
                            v1 = v14 = 'Strawberry';
                        }
                    } else {
                        v1 = v15 = '4.jpg';
                        v1 = v16 = 'Grapes';
                    }
                } else {
                    v1 = v17 = '3.jpg';
                    v1 = v18 = 0x4c696d65;
                }
            } else {
                v1 = v19 = '2.jpg';
                v1 = v20 = 'Banana';
            }
        } else {
            v1 = v21 = '1.jpg';
            v1 = v22 = 'Apple';
        }
        v23 = 0x2792(tokenId);
        MEM[32 + MEM[64]] = '{"name": "Fruits #';
        v24 = v25 = 0;
        while (v24 < v23.length) {
            MEM[32 + MEM[64] + 18 + v24] = v23[v24];
            v24 = v24 + 32;
        }
        MEM[32 + MEM[64] + 18 + v23.length] = 0;
        MEM[64] = 32 + MEM[64] + 18 + v23.length;
        v26 = v27 = 0;
        while (v26 < 32 + MEM[64] + 18 + v23.length - MEM[64] - 32) {
            MEM[32 + MEM[64] + v26] = MEM[MEM[64] + 32 + v26];
            v26 = v26 + 32;
        }
        MEM[32 + MEM[64] + (32 + MEM[64] + 18 + v23.length - MEM[64] - 32)] = 0;
        MEM[32 + MEM[64] + (32 + MEM[64] + 18 + v23.length - MEM[64] - 32)] = '","description":"A collection of';
        MEM[32 + MEM[64] + (32 + MEM[64] + 18 + v23.length - MEM[64] - 32) + 32] = ' 10,000 Fruits enabled by ERC404';
        MEM[32 + MEM[64] + (32 + MEM[64] + 18 + v23.length - MEM[64] - 32) + 64] = ', an experimental token standard';
        MEM[32 + MEM[64] + (32 + MEM[64] + 18 + v23.length - MEM[64] - 32) + 96] = '.","external_url":"https://fruit';
        MEM[32 + MEM[64] + (32 + MEM[64] + 18 + v23.length - MEM[64] - 32) + 128] = 's404.io/","image":"';
        MEM[64] = 32 + MEM[64] + (32 + MEM[64] + 18 + v23.length - MEM[64] - 32) + 147;
        v28 = 0x3a19(12, 32 + MEM[64]);
        v29 = v30 = 0;
        while (v29 < MEM[v1]) {
            MEM[v28 + v29] = MEM[v1 + 32 + v29];
            v29 = v29 + 32;
        }
        MEM[v28 + MEM[v1]] = 0;
        MEM[64] = v28 + MEM[v1];
        v31 = v32 = 0;
        while (v31 < 32 + MEM[64] + (32 + MEM[64] + 18 + v23.length - MEM[64] - 32) + 147 - MEM[64] - 32) {
            MEM[32 + MEM[64] + v31] = MEM[MEM[64] + 32 + v31];
            v31 = v31 + 32;
        }
        MEM[32 + MEM[64] + (32 + MEM[64] + (32 + MEM[64] + 18 + v23.length - MEM[64] - 32) + 147 - MEM[64] - 32)] = 0;
        v33 = v34 = 0;
        while (v33 < v28 + MEM[v1] - MEM[64] - 32) {
            MEM[32 + MEM[64] + (32 + MEM[64] + (32 + MEM[64] + 18 + v23.length - MEM[64] - 32) + 147 - MEM[64] - 32) + v33] = MEM[MEM[64] + 32 + v33];
            v33 = v33 + 32;
        }
        MEM[32 + MEM[64] + (32 + MEM[64] + (32 + MEM[64] + 18 + v23.length - MEM[64] - 32) + 147 - MEM[64] - 32) + (v28 + MEM[v1] - MEM[64] - 32)] = 0;
        MEM[64] = 32 + MEM[64] + (32 + MEM[64] + (32 + MEM[64] + 18 + v23.length - MEM[64] - 32) + 147 - MEM[64] - 32) + (v28 + MEM[v1] - MEM[64] - 32);
        MEM[32 + MEM[64]] = '","attributes":[{"trait_type":"f';
        MEM[32 + MEM[64] + 32] = 'ruit","value":"';
        v35 = v36 = 0;
        while (v35 < MEM[v1]) {
            MEM[32 + MEM[64] + 47 + v35] = MEM[v1 + 32 + v35];
            v35 = v35 + 32;
        }
        MEM[32 + MEM[64] + 47 + MEM[v1]] = 0;
        MEM[64] = 32 + MEM[64] + 47 + MEM[v1];
        v37 = v38 = 0;
        while (v37 < 32 + MEM[64] + (32 + MEM[64] + (32 + MEM[64] + 18 + v23.length - MEM[64] - 32) + 147 - MEM[64] - 32) + (v28 + MEM[v1] - MEM[64] - 32) - MEM[64] - 32) {
            MEM[32 + MEM[64] + v37] = MEM[MEM[64] + 32 + v37];
            v37 = v37 + 32;
        }
        MEM[32 + MEM[64] + (32 + MEM[64] + (32 + MEM[64] + (32 + MEM[64] + 18 + v23.length - MEM[64] - 32) + 147 - MEM[64] - 32) + (v28 + MEM[v1] - MEM[64] - 32) - MEM[64] - 32)] = 0;
        v39 = v40 = 0;
        while (v39 < 32 + MEM[64] + 47 + MEM[v1] - MEM[64] - 32) {
            MEM[32 + MEM[64] + (32 + MEM[64] + (32 + MEM[64] + (32 + MEM[64] + 18 + v23.length - MEM[64] - 32) + 147 - MEM[64] - 32) + (v28 + MEM[v1] - MEM[64] - 32) - MEM[64] - 32) + v39] = MEM[MEM[64] + 32 + v39];
            v39 = v39 + 32;
        }
        MEM[32 + MEM[64] + (32 + MEM[64] + (32 + MEM[64] + (32 + MEM[64] + 18 + v23.length - MEM[64] - 32) + 147 - MEM[64] - 32) + (v28 + MEM[v1] - MEM[64] - 32) - MEM[64] - 32) + (32 + MEM[64] + 47 + MEM[v1] - MEM[64] - 32)] = 0;
        MEM[64] = 32 + MEM[64] + (32 + MEM[64] + (32 + MEM[64] + (32 + MEM[64] + 18 + v23.length - MEM[64] - 32) + 147 - MEM[64] - 32) + (v28 + MEM[v1] - MEM[64] - 32) - MEM[64] - 32) + (32 + MEM[64] + 47 + MEM[v1] - MEM[64] - 32);
        v41 = v42 = 0;
        while (v41 < 32 + MEM[64] + (32 + MEM[64] + (32 + MEM[64] + (32 + MEM[64] + 18 + v23.length - MEM[64] - 32) + 147 - MEM[64] - 32) + (v28 + MEM[v1] - MEM[64] - 32) - MEM[64] - 32) + (32 + MEM[64] + 47 + MEM[v1] - MEM[64] - 32) - MEM[64] - 32) {
            MEM[32 + MEM[64] + v41] = MEM[MEM[64] + 32 + v41];
            v41 = v41 + 32;
        }
        MEM[32 + MEM[64] + (32 + MEM[64] + (32 + MEM[64] + (32 + MEM[64] + (32 + MEM[64] + 18 + v23.length - MEM[64] - 32) + 147 - MEM[64] - 32) + (v28 + MEM[v1] - MEM[64] - 32) - MEM[64] - 32) + (32 + MEM[64] + 47 + MEM[v1] - MEM[64] - 32) - MEM[64] - 32)] = 0;
        v43 = v44 = 0;
        while (v43 < v45.length) {
            MEM[32 + MEM[64] + (32 + MEM[64] + (32 + MEM[64] + (32 + MEM[64] + (32 + MEM[64] + 18 + v23.length - MEM[64] - 32) + 147 - MEM[64] - 32) + (v28 + MEM[v1] - MEM[64] - 32) - MEM[64] - 32) + (32 + MEM[64] + 47 + MEM[v1] - MEM[64] - 32) - MEM[64] - 32) + v43] = v45[v43];
            v43 = v43 + 32;
        }
        MEM[32 + MEM[64] + (32 + MEM[64] + (32 + MEM[64] + (32 + MEM[64] + (32 + MEM[64] + 18 + v23.length - MEM[64] - 32) + 147 - MEM[64] - 32) + (v28 + MEM[v1] - MEM[64] - 32) - MEM[64] - 32) + (32 + MEM[64] + 47 + MEM[v1] - MEM[64] - 32) - MEM[64] - 32) + v45.length] = 0;
        MEM[64] = 32 + MEM[64] + (32 + MEM[64] + (32 + MEM[64] + (32 + MEM[64] + (32 + MEM[64] + 18 + v23.length - MEM[64] - 32) + 147 - MEM[64] - 32) + (v28 + MEM[v1] - MEM[64] - 32) - MEM[64] - 32) + (32 + MEM[64] + 47 + MEM[v1] - MEM[64] - 32) - MEM[64] - 32) + v45.length;
        MEM[32 + MEM[64]] = 'data:application/json;utf8,';
        v46 = v47 = 0;
        while (v46 < 32 + MEM[64] + (32 + MEM[64] + (32 + MEM[64] + (32 + MEM[64] + (32 + MEM[64] + 18 + v23.length - MEM[64] - 32) + 147 - MEM[64] - 32) + (v28 + MEM[v1] - MEM[64] - 32) - MEM[64] - 32) + (32 + MEM[64] + 47 + MEM[v1] - MEM[64] - 32) - MEM[64] - 32) + v45.length - MEM[64] - 32) {
            MEM[32 + MEM[64] + 27 + v46] = MEM[MEM[64] + 32 + v46];
            v46 = v46 + 32;
        }
        MEM[32 + MEM[64] + 27 + (32 + MEM[64] + (32 + MEM[64] + (32 + MEM[64] + (32 + MEM[64] + (32 + MEM[64] + 18 + v23.length - MEM[64] - 32) + 147 - MEM[64] - 32) + (v28 + MEM[v1] - MEM[64] - 32) - MEM[64] - 32) + (32 + MEM[64] + 47 + MEM[v1] - MEM[64] - 32) - MEM[64] - 32) + v45.length - MEM[64] - 32)] = 0;
        v48 = MEM[64];
        MEM[v48] = 32 + MEM[64] + 27 + (32 + MEM[64] + (32 + MEM[64] + (32 + MEM[64] + (32 + MEM[64] + (32 + MEM[64] + 18 + v23.length - MEM[64] - 32) + 147 - MEM[64] - 32) + (v28 + MEM[v1] - MEM[64] - 32) - MEM[64] - 32) + (32 + MEM[64] + 47 + MEM[v1] - MEM[64] - 32) - MEM[64] - 32) + v45.length - MEM[64] - 32) - v48 - 32;
        MEM[64] = 32 + MEM[64] + 27 + (32 + MEM[64] + (32 + MEM[64] + (32 + MEM[64] + (32 + MEM[64] + (32 + MEM[64] + 18 + v23.length - MEM[64] - 32) + 147 - MEM[64] - 32) + (v28 + MEM[v1] - MEM[64] - 32) - MEM[64] - 32) + (32 + MEM[64] + 47 + MEM[v1] - MEM[64] - 32) - MEM[64] - 32) + v45.length - MEM[64] - 32);
    } else {
        v49 = 0x2792(tokenId);
        v50 = 0x3a19(13, 32 + MEM[64]);
        v51 = v52 = 0;
        while (v51 < v49.length) {
            MEM[v50 + v51] = v49[v51];
            v51 = v51 + 32;
        }
        MEM[v50 + v49.length] = 0;
        v48 = v53 = MEM[64];
        MEM[v53] = v50 + v49.length - v53 - 32;
        MEM[64] = v50 + v49.length;
    }
    v54 = new uint256[](MEM[v48]);
    v55 = v56 = 0;
    while (v55 < MEM[v48]) {
        MEM[v54.data + v55] = MEM[v48 + 32 + v55];
        v55 = v55 + 32;
    }
    MEM[v54.data + MEM[v48]] = 0;
    return v54;
}

function baseTokenURI() public payable { 
    v0, v1 = 0x2024();
    v2 = new bytes[](v0.length);
    v3 = v4 = 0;
    while (v3 < v0.length) {
        v2[v3] = v0[v3];
        v3 = v3 + 32;
    }
    v2[v0.length] = 0;
    return v2;
}

function allowance(address owner, address spender) public payable { 
    require(4 + (msg.data.length - 4) - 4 >= 64);
    return _allowance[owner][spender];
}

function setTokenURI(string newURI) public payable { 
    require(4 + (msg.data.length - 4) - 4 >= 32);
    require(newURI <= uint64.max);
    require(4 + newURI + 31 < 4 + (msg.data.length - 4));
    require(newURI.length <= uint64.max, Panic(65)); // failed memory allocation (too much memory)
    v0 = new bytes[](newURI.length);
    require(!((v0 + ((newURI.length + 31 & ~0x1f) + 32 + 31 & ~0x1f) > uint64.max) | (v0 + ((newURI.length + 31 & ~0x1f) + 32 + 31 & ~0x1f) < v0)), Panic(65)); // failed memory allocation (too much memory)
    require(newURI.data + newURI.length <= 4 + (msg.data.length - 4));
    CALLDATACOPY(v0.data, newURI.data, newURI.length);
    v0[newURI.length] = 0;
    0x20d0(v0);
}

function isApprovedForAll(address owner, address operator) public payable { 
    require(4 + (msg.data.length - 4) - 4 >= 64);
    return bool(_isApprovedForAll[owner][operator]);
}

function dataURI() public payable { 
    v0, v1 = 0x2191();
    v2 = new bytes[](v0.length);
    v3 = v4 = 0;
    while (v3 < v0.length) {
        v2[v3] = v0[v3];
        v3 = v3 + 32;
    }
    v2[v0.length] = 0;
    return v2;
}

function transferOwnership(address newOwner) public payable { 
    require(4 + (msg.data.length - 4) - 4 >= 32);
    require(msg.sender == _owner, Unauthorized());
    require(newOwner - address(0x0), InvalidOwner());
    _owner = newOwner;
    emit OwnershipTransferred(msg.sender, newOwner);
}

function 0x551() private { 
    v0 = 0x3546(array_1.length);
    v1 = new bytes[](v0);
    v2 = v3 = v1.data;
    v4 = 0x3546(array_1.length);
    if (!v4) {
        return v1, v5;
    } else if (31 < v4) {
        v6 = v7 = array_1.data;
        do {
            MEM[v2] = STORAGE[v6];
            v6 += 1;
            v2 += 32;
        } while (v3 + v4 <= v2);
        return v1, v5;
    } else {
        MEM[v3] = array_1.length >> 8 << 8;
        return v1, v5;
    }
}

function 0x918(bytes varg0) private { 
    require(msg.sender == _owner, Unauthorized());
    require(varg0.length <= uint64.max, Panic(65)); // failed memory allocation (too much memory)
    v0 = 0x3546(array_c.length);
    if (v0 > 31) {
        v1 = v2 = array_c.data;
        v1 = v3 = v2 + (varg0.length + 31 >> 5);
        while (v1 < v2 + (v0 + 31 >> 5)) {
            STORAGE[v1] = STORAGE[v1] & ~0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff | uint256(0);
            v1 = v1 + 1;
        }
    }
    v4 = v5 = 32;
    if (varg0.length > 31 == 1) {
        v6 = array_c.data;
        v7 = v8 = 0;
        while (v7 < varg0.length & ~0x1f) {
            STORAGE[v6] = MEM[varg0 + v4];
            v6 = v6 + 1;
            v4 = v4 + 32;
            v7 = v7 + 32;
        }
        if (varg0.length & ~0x1f < varg0.length) {
            STORAGE[v6] = MEM[varg0 + v4] & ~(~0 >> ((varg0.length & 0x1f) << 3));
        }
        array_c = (varg0.length << 1) + 1;
    } else {
        v9 = v10 = 0;
        if (varg0.length) {
            v9 = MEM[varg0.data];
        }
        array_c = v9 & ~(~0 >> (varg0.length << 3)) | varg0.length << 1;
    }
    return ;
}

function 0x9af(uint256 varg0, uint256 varg1, uint256 varg2) private { 
    if (varg0 > _minted) {
        if (_allowance[address(varg2)][msg.sender] != uint256.max) {
            v0 = _SafeSub(_allowance[address(varg2)][msg.sender], varg0);
            _allowance[address(varg2)][msg.sender] = v0;
        }
        v1 = 0x23d5(varg0, varg1, varg2);
    } else {
        require(address(varg2) == address(_ownerOf[varg0]), InvalidSender());
        require(address(varg1) - address(0x0), InvalidRecipient());
        v2 = v3 = msg.sender != address(varg2);
        if (msg.sender != address(varg2)) {
            v2 = v4 = !uint8(_isApprovedForAll[address(address(varg2))][address(address(msg.sender))]);
        }
        if (v2) {
            v2 = v5 = msg.sender != address(_getApproved[varg0]);
        }
        require(!v2, Unauthorized());
        v6 = 0x23a2();
        v7 = _SafeSub(_balanceOf[address(varg2)], v6);
        _balanceOf[address(varg2)] = v7;
        v8 = 0x23a2();
        _balanceOf[address(varg1)] = _balanceOf[address(varg1)] + v8;
        _ownerOf[varg0] = address(varg1) | bytes12(_ownerOf[varg0]);
        _getApproved[varg0] = bytes12(_getApproved[varg0]);
        v9 = _SafeSub(owner_9[address(varg2)].field0.length, 1);
        require(v9 < owner_9[address(varg2)].field0.length, Panic(50)); // access an out-of-bounds or negative index of bytesN array or slice
        require(owner_a[varg0] < owner_9[address(varg2)].field0.length, Panic(50)); // access an out-of-bounds or negative index of bytesN array or slice
        owner_9[address(varg2)].field0[owner_a[varg0]] = owner_9[address(varg2)].field0[v9];
        v10 = address(varg2);
        require(owner_9[v10].field0.length, Panic(49)); // attemp to .pop an empty array
        owner_9[v10].field0[owner_9[v10].field0.length - 1] = 0;
        owner_9[v10].field0.length = owner_9[v10].field0.length - 1;
        owner_a[owner_9[address(varg2)].field0[v9]] = owner_a[varg0];
        v11 = address(varg1);
        owner_9[v11].field0.length = owner_9[v11].field0.length + 1;
        owner_9[v11].field0[owner_9[v11].field0.length + 1 - 1] = varg0;
        v12 = _SafeSub(owner_9[address(varg1)].field0.length, 1);
        owner_a[varg0] = v12;
        emit Transfer(address(varg2), address(varg1), varg0);
        v13 = 0x23a2();
        emit 0xe59fdd36d0d223c0c7d996db7ad796880f45e1936cb0bb7ac102e7082e031487(address(varg2), address(varg1), v13);
    }
    return ;
}

// Note: The function selector is not present in the original solidity code.
// However, we display it for the sake of completeness.

function function_selector( function_selector) public payable { 
    MEM[64] = 128;
    require(!msg.value);
    if (msg.data.length < 4) {
        fallback();
    } else {
        v0 = function_selector >> 224;
        if (0x70a08231 > v0) {
            if (0x2b968958 > v0) {
                if (0x6fdde03 == v0) {
                    name();
                } else if (0x81812fc == v0) {
                    getApproved(uint256);
                } else if (0x95ea7b3 == v0) {
                    approve(address,uint256);
                } else if (0x18160ddd == v0) {
                    totalSupply();
                } else if (0x18d217c3 == v0) {
                    setDataURI(string);
                } else {
                    require(0x23b872dd == v0);
                    transferFrom(address,address,uint256);
                }
            } else if (0x4f02c420 > v0) {
                if (0x2b968958 == v0) {
                    revokeOwnership();
                } else if (0x313ce567 == v0) {
                    decimals();
                } else {
                    require(0x42842e0e == v0);
                    safeTransferFrom(address,address,uint256);
                }
            } else if (0x4f02c420 == v0) {
                minted();
            } else if (0x504334c2 == v0) {
                setNameSymbol(string,string);
            } else if (0x53d6fd59 == v0) {
                setWhitelist(address,bool);
            } else {
                require(0x6352211e == v0);
                ownerOf(uint256);
            }
        } else if (0xc87b56dd > v0) {
            if (0x9b19251a > v0) {
                if (0x70a08231 == v0) {
                    balanceOf(address);
                } else if (0x8da5cb5b == v0) {
                    owner();
                } else {
                    require(0x95d89b41 == v0);
                    symbol();
                }
            } else if (0x9b19251a == v0) {
                whitelist(address);
            } else if (0xa22cb465 == v0) {
                setApprovalForAll(address,bool);
            } else if (0xa9059cbb == v0) {
                transfer(address,uint256);
            } else {
                require(0xb88d4fde == v0);
                safeTransferFrom(address,address,uint256,bytes);
            }
        } else if (0xe0df5b6f > v0) {
            if (0xc87b56dd == v0) {
                tokenURI(uint256);
            } else if (0xd547cfb7 == v0) {
                baseTokenURI();
            } else {
                require(0xdd62ed3e == v0);
                allowance(address,address);
            }
        } else if (0xe0df5b6f == v0) {
            setTokenURI(string);
        } else if (0xe985e9c5 == v0) {
            isApprovedForAll(address,address);
        } else if (0xf28ca1dd == v0) {
            dataURI();
        } else {
            require(0xf2fde38b == v0);
            transferOwnership(address);
        }
    }
}
