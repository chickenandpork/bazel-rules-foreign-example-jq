# example/transitions/transitions.bzl
def _impl(settings, attr):
    _ignore = (settings, attr)
    return {
        "Intel": {"//command_line_option:cpu": "darwin_amd64"},
        "M1": {"//command_line_option:cpu": "darwin_arm64"},
    }

multi_arch_transition = transition(
    implementation = _impl,
    inputs = [],
    outputs = ["//command_line_option:cpu"],
)

def _rule_impl(ctx):
    jq_amd = ctx.split_attr.jq["Intel"]
    jq_arm = ctx.split_attr.jq["M1"]

    return [DefaultInfo(files = depset([jq_arm, jq_amd]))]

my_custom_multi_arch_rule = rule(
    implementation = _rule_impl,
    attrs = {
        "jq": attr.label(cfg = multi_arch_transition),
        "_allowlist_function_transition": attr.label(
            default = "@bazel_tools//tools/allowlists/function_transition_allowlist",
        ),
    },
)
