--冰晶魔女 露娜
local m=10700081
local cm=_G["c"..m]

function cm.initial_effect(c)
	c:EnableCounterPermit(0x1)
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
    cm.AddLinkProcedure(c,0,nil,3,6,cm.lcheck)
    cm.AddLinkProcedure(c,1,nil,3,6,cm.lcheck2)
    c:EnableReviveLimit()
    --splimit
	local e0=Effect.CreateEffect(c)
    e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_SPSUMMON_SUCCESS)
	e0:SetCondition(cm.regcon)
	e0:SetOperation(cm.regop)
	c:RegisterEffect(e0)
    --spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,m)
	e2:SetCondition(cm.regcon)
	e2:SetTarget(cm.thtg)
	e2:SetOperation(cm.thop)
	c:RegisterEffect(e2)
    --release
    local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_MZONE)
	e1:SetCost(cm.recost)
	e1:SetTarget(cm.retg)
	e1:SetOperation(cm.reop)
	c:RegisterEffect(e1)
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
	return g:IsExists(Card.IsLink,2,nil,2)
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

function cm.tgtfilter(c,e)
	return c:IsType(TYPE_MONSTER) and (c:IsLocation(0x10) or (c:IsLocation(LOCATION_REMOVED) and c:IsFaceup()))
		and c:IsCanBeEffectTarget(e)
end

function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    local c=e:GetHandler()
    local mg=c:GetMaterial()
    if #mg<=0 then return false end
    if chkc then return mg:IsContains(chkc) and cm.tgtfilter(chkc,e) end
	if chk==0 then return mg:IsExists(cm.tgtfilter,1,nil,e) and c:IsCanAddCounter(0x1,1) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=mg:FilterSelect(tp,cm.tgtfilter,1,2,nil,e)
    Duel.SetTargetCard(g)
end

function cm.thop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
    if c:IsRelateToEffect(e) and #tg>0 then
        local tc=tg:GetFirst()
        local lnum=0
        while tc do
            if not tc:IsType(TYPE_LINK) then
                lnum=lnum+1
            else
                lnum=lnum+tc:GetLink()
            end
            tc=tg:GetNext()
        end
        c:AddCounter(0x1,lnum)
    end
end

function cm.costcfilter(c,tp)
    if c:IsCanRemoveCounter(tp,0x1,c:GetCounter(0x1),REASON_COST) then
        if Duel.GetFlagEffectLabel(tp,m+1)==nil then
            return true
        else
            return not c:IsCode(Duel.GetFlagEffectLabel(tp,m+1))
        end
    else
        return false
    end
end

function cm.costrfilter(c,tp)
    if c:IsType(TYPE_SPELL) and c:IsAbleToRemoveAsCost() and (c:IsFaceup() or c:IsLocation(0x10)) then
        if Duel.GetFlagEffectLabel(tp,m+2)==nil then
            return true
        else
            return not c:IsCode(Duel.GetFlagEffectLabel(tp,m+2))
        end
    else
        return false
    end
end

function cm.recost(e,tp,eg,ep,ev,re,r,rp,chk)
    local cg=Duel.GetMatchingGroup(cm.costcfilter,tp,0x0c,0,nil,tp)
    local rg=Duel.GetMatchingGroup(cm.costrfilter,tp,0x18,0,nil,tp)
	if chk==0 then return #cg>0 and #rg>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_COUNTER)
	local cc=cg:Select(tp,1,1,nil):GetFirst()
    local cnum=cc:GetCounter(0x1)
    cc:RemoveCounter(tp,0x1,cnum,REASON_COST)
    Duel.RegisterFlagEffect(tp,m+1,RESET_PHASE+PHASE_END,0,1,cc:GetCode())
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local rcg=rg:Select(tp,1,1,nil)
    if not rcg then return false end
    Duel.Remove(rcg,POS_FACEUP,REASON_COST)
    Duel.RegisterFlagEffect(tp,m+2,RESET_PHASE+PHASE_END,0,1,rcg:GetFirst():GetCode())
    e:SetLabel(cnum)
end

function cm.retg(e,tp,eg,ep,ev,re,r,rp,chk)
    local g=Duel.GetFieldGroup(tp,0,0x0c)
	if chk==0 then return #g>0 end
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,nil,nil)
    Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,e:GetLabel()*100)
end

function cm.reop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,0x0c,1,1,nil)
    if #g>0 then
        Duel.HintSelection(g)
        if Duel.Destroy(g,REASON_EFFECT) then
            Duel.BreakEffect()
            Duel.Recover(tp,e:GetLabel()*100,REASON_EFFECT)
        end
    end
end