pragma solidity ^0.4.15;

import './utils/StringUtils.sol';
import './NPO.sol';

contract Config {
    address owner;
    Donations donationsContract;

    struct NPOMetadata {
        address npoAddress;
        string name;
        string description;
        string[] buckets;
        string[] tags;
    }

    NPOMetadata[] private NPOs;
    string[] private allBuckets;
    string[] private allTags;
    mapping(string => NPOMetadata) private NPOMeta;
    mapping(string => NPOMetadata[]) private tagToNPO;
    mapping(string => NPOMetadata[]) private bucketToNPO;

    function Config() { // NOTE: should only ever be instantiated once!
        owner = msg.sender;
        // instantate and set the owner of Donations
        donationsContract = new Donations(msg.sender);
    }

    function register(string name, string description, string[] buckets, string[] tags) returns (bool) {
        for (uint i = 0; i < NPOs.length; i++) {
            if (StringUtils.equal(NPOs[i].name, name)) {
                return false;
            }
        }

        NPO newNPO = new NPO(msg.sender);
        NPOMetadata storage newNPOMeta = NPOMetadata(address(newNPO), name, description, buckets, tags);
        NPOMeta[name] = newNPOMeta;
        NPOs.push(newNPOMeta);

        for (i = 0; i < buckets.length; i++) {
            bucketToNPO[buckets[i]].push(newNPOMeta);
            bool found = false;
            for (uint j = 0; j < allBuckets.length; j++) {
                if (StringUtils.equal(allBuckets[j], buckets[i])) {
                    found = true;
                    break;
                }
            }
            if (!found) {
                allBuckets.push(buckets[i]);
            }
        }

        for (i = 0; i < tags.length; i++) {
            tagToNPO[tags[i]].push(newNPOMeta);
            found = false;
            for (j = 0; j < allTags.length; j++) {
                if (StringUtils.equal(allTags[j], tags[i])) {
                    found = true;
                    break;
                }
            }
            if (!found) {
                allTags.push(tags[i]);
            }
        }

        return true;
    }

    function getNPO(string name) returns (string, string, string[], string[]) {
        NPOMetadata metadata = NPOMeta[name];
        return (metadata.name, metadata.description, metadata.buckets, metadata.tags);
    }

    function getBuckets(address npo) returns (string[]) {
        return allBuckets;
    }

    function getTags() returns (string[]) {
        return allTags;
    }

    function searchBucket(string bucket) returns (string[]) {
        string[] metadata =
        for (int i = 0; i < bucketToNPO[bucket].length; i++) {
          
        }
        return bucketToNPO[bucket];
    }

    function searchTag(string tag) returns (NPOMetadata[]) {
        return tagToNPO[tag];
    }
}
