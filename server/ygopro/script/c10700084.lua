--玩偶魔女 艾露迪
local m=10700084
local cm=_G["c"..m]

function cm.initial_effect(c)
	function cm.AddLinkProcedure(c,ck,f,min,max,gf)
        local e1=Effect.CreateEffect(c)
        e1:SetDescription(1166)
        e1:SetType(EFFECT_TYPE_FIELD)
        e1:SetCode(EFFECT_SPSUMMON_PROC)
        e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
        e1:SetRange(LOCATION_EXTRA)
        if max==nil then max=c:GetLink() end
        e1:SetCondition(cm.LinkCondition(ck,f,min,max,gf))
        e1:SetTarget(Auxiliary.LinkTarget(f,min,max,gf))
        e1:SetOperation(Auxiliary.LinkOperation(f,min,max,gf))
        e1:SetValue(SUMMON_TYPE_LINK)
        c:RegisterEffect(e1)
        return e1
    end
	cm.AddLinkProcedure(c,0,aux.FilterBoolFunction(Card.IsRace,RACE_SPELLCASTER),5,7,cm.lcheck)
	cm.AddLinkProcedure(c,1,nil,3,7,cm.lcheck2)
    c:EnableReviveLimit()
    --splimit
	local e0=Effect.CreateEffect(c)
    e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_SPSUMMON_SUCCESS)
	e0:SetCondition(cm.regcon)
	e0:SetOperation(cm.regop)
	c:RegisterEffect(e0)
    --attack
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_EXTRA_ATTACK_MONSTER)
    e4:SetCondition(cm.regcon)
	e4:SetValue(6)
	c:RegisterEffect(e4)
    --attackup
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetCondition(cm.atkcon)
    e1:SetValue(cm.atkval)
    c:RegisterEffect(e1)
    --immune
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetCode(EFFECT_IMMUNE_EFFECT)
	e5:SetRange(LOCATION_MZONE)
	e5:SetValue(cm.efilter)
	c:RegisterEffect(e5)
    if not cm.global_check then
        cm.global_check=true
        local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
        ge1:SetCondition(cm.checkcon)
		ge1:SetOperation(cm.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_ADJUST)
		ge2:SetOperation(cm.adckop)
		Duel.RegisterEffect(ge2,0)
    end
end

function cm.LinkCondition(ck,f,minc,maxc,gf)
	return	function(e,c,og,lmat,min,max)
				if c==nil then return true end
				if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
				local minc=minc
				local maxc=maxc
				if min then
					if min>minc then minc=min end
					if max<maxc then maxc=max end
					if minc>maxc then return false end
				end
				local tp=c:GetControler()
				local mg=nil
				if og then
					mg=og:Filter(Auxiliary.LConditionFilter,nil,f,c,e)
				else
					mg=Auxiliary.GetLinkMaterials(tp,f,c,e)
				end
				if lmat~=nil then
					if not Auxiliary.LConditionFilter(lmat,f,c,e) then return false end
					mg:AddCard(lmat)
				end
				local fg=Auxiliary.GetMustMaterialGroup(tp,EFFECT_MUST_BE_LMATERIAL)
				if fg:IsExists(Auxiliary.MustMaterialCounterFilter,1,nil,mg) then return false end
				Duel.SetSelectedCard(fg)
                if ck==0 then
                    return Duel.GetFlagEffect(tp,m)==0 and mg:CheckSubGroup(Auxiliary.LCheckGoal,minc,maxc,tp,c,gf,lmat)
                else
                    return Duel.GetFlagEffect(tp,m)~=0 and mg:CheckSubGroup(Auxiliary.LCheckGoal,minc,maxc,tp,c,gf,lmat)
                end
			end
end

function cm.concfilter(c)
    return c:IsRace(RACE_SPELLCASTER) and c:IsType(TYPE_PENDULUM) and c:IsSummonType(SUMMON_TYPE_PENDULUM)
end

function cm.checkcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.concfilter,1,nil)
end

function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(cm.concfilter,nil)
    local tc=g:GetFirst()
	while tc do
		Duel.RegisterFlagEffect(tc:GetSummonPlayer(),m,RESET_PHASE+PHASE_END,0,1)
		tc=eg:GetNext()
	end
end

function cm.adckop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tp=c:GetControler()
	if Duel.GetFlagEffect(tp,m)==0 and c:GetFlagEffect(m)~=0 then
        c:ResetFlagEffect(m)
    end
    if Duel.GetFlagEffect(tp,m)~=0 and c:GetFlagEffect(m)==0 then
        c:RegisterFlagEffect(m,RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,3))
    end
end

function cm.lcheck(g)
	return g:IsExists(Card.IsLink,1,nil,3)
end

function cm.lcheck2(g)
	return g:IsExists(Card.IsRace,1,nil,RACE_SPELLCASTER) and g:IsExists(Card.IsType,1,nil,TYPE_PENDULUM)
end

function cm.regcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(e:GetHandler():GetSummonType(),SUMMON_TYPE_LINK)==SUMMON_TYPE_LINK
end

function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTarget(cm.splimit)
	Duel.RegisterEffect(e1,tp)
end

function cm.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsCode(m) and bit.band(sumtype,SUMMON_TYPE_LINK)==SUMMON_TYPE_LINK
end

function cm.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE
end

function cm.atkval(e,c)
    local tp=c:GetControler()
    if Duel.GetCounter(tp,0x0c,0,0x1)>0 then
        return Duel.GetCounter(tp,0x0c,0x0c,0x1)*300
    else
        return Duel.GetCounter(tp,0x0c,0x0c,0x1)*300+Duel.GetMatchingGroupCount(Card.IsType,tp,0x10,0x10,nil,TYPE_SPELL)*100
    end
end

function cm.efilter(e,te)
	return te:IsActiveType(TYPE_SPELL) and e:GetOwnerPlayer()~=te:GetOwnerPlayer()
end