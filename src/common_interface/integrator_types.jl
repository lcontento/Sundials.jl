mutable struct DEOptions{SType,TstopType,CType}
    saveat::SType
    tstops::TstopType
    save_everystep::Bool
    dense::Bool
    timeseries_errors::Bool
    dense_errors::Bool
    save_end::Bool
    callback::CType
end

abstract type AbstractSundialsIntegrator <: AbstractODEIntegrator end

mutable struct CVODEIntegrator{uType,memType,solType,algType,fType,UFType,JType,oType,toutType,sizeType,tmpType} <: AbstractSundialsIntegrator
    u::uType
    t::Float64
    tprev::Float64
    mem::memType
    sol::solType
    alg::algType
    f::fType
    userfun::UFType
    jac::JType
    opts::oType
    tout::toutType
    tdir::Float64
    sizeu::sizeType
    u_modified::Bool
    tmp::tmpType
    uprev::tmpType
    flag::Cint
end

function (integrator::CVODEIntegrator)(t::Number,deriv::Type{Val{T}}=Val{0}) where T
    out = similar(integrator.u)
    integrator.flag = @checkflag CVodeGetDky(integrator.mem, t, Cint(T), out)
    out
end

function (integrator::CVODEIntegrator)(out,t::Number,
                                          deriv::Type{Val{T}}=Val{0}) where T
    integrator.flag = @checkflag CVodeGetDky(integrator.mem, t, Cint(T), out)
end

mutable struct IDAIntegrator{uType,duType,memType,solType,algType,fType,UFType,JType,oType,toutType,sizeType,sizeDType,tmpType} <: AbstractSundialsIntegrator
    u::uType
    du::duType
    t::Float64
    tprev::Float64
    mem::memType
    sol::solType
    alg::algType
    f::fType
    userfun::UFType
    jac::JType
    opts::oType
    tout::toutType
    tdir::Float64
    sizeu::sizeType
    sizedu::sizeDType
    u_modified::Bool
    tmp::tmpType
    uprev::tmpType
    flag::Cint
end

function (integrator::IDAIntegrator)(t::Number,deriv::Type{Val{T}}=Val{0}) where T
    out = similar(integrator.u)
    integrator.flag = @checkflag IDAGetDky(integrator.mem, t, Cint(T), out)
    out
end

function (integrator::IDAIntegrator)(out,t::Number,
                                          deriv::Type{Val{T}}=Val{0}) where T
    integrator.flag = @checkflag IDAGetDky(integrator.mem, t, Cint(T), out)
end
