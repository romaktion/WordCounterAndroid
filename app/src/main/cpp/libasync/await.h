#pragma once
#include <future>

template<typename L>
decltype(auto) __await_async(L lambda)
{
	auto f = std::async(std::launch::deferred, [=]()
	{
		auto r = lambda();
		return r;
	});

	return f.get();
}
#define await(l) __await_async(l)

#ifdef libasync_EXPORTS
#define libasync_API __declspec(dllexport)
#else
#define libasync_API __declspec(dllimport)
#endif

class
#ifdef _WIN32
	libasync_API
#endif
	async
{};
