local m=27819078
local cm=_G["c"..m]
cm.name="五王-天启修诺"
cm.SetCard_fiveking=true
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddXyzProcedureLevelFree(c,cm.mfilter,cm.xyzcheck,2,2)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetCondition(cm.matcon)
	e1:SetValue(cm.efilter)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(cm.descost)
	e2:SetTarget(cm.destg)
	e2:SetOperation(cm.desop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_DISABLE)
	e3:SetTargetRange(0,LOCATION_SZONE)
	e3:SetCondition(cm.matcon)
	e3:SetTarget(cm.distg)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_CHAIN_SOLVING)
	e4:SetCondition(cm.matcon)
	e4:SetOperation(cm.disop)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_DISABLE_TRAPMONSTER)
	e5:SetTargetRange(0,LOCATION_MZONE)
	e5:SetCondition(cm.matcon)
	e5:SetTarget(cm.distg)
	c:RegisterEffect(e5)
end
function cm.mfilter(c,xyzc)
	return c:IsXyzType(TYPE_XYZ) and not c:IsSetCard(0x48)
end
function cm.xyzcheck(g)
	return g:GetClassCount(Card.GetRank)==1
end
function cm.filter(c)
	local tcm=_G["c"..c:GetOriginalCodeRule()]
	return tcm.SetCard_fiveking
end
function cm.matcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayGroup():IsExists(cm.filter,1,nil)
end
function cm.efilter(e,re)
	return e:GetHandlerPlayer()~=re:GetOwnerPlayer()
end
function cm.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,0)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_MZONE,1,1,nil)
	if g:GetCount()>0 then
		local atk=g:GetFirst():GetAttack()
		if atk<0 then atk=0 end
		Duel.HintSelection(g)
		if Duel.Destroy(g,REASON_EFFECT)~=0 then
			Duel.Damage(1-tp,atk/2,REASON_EFFECT)
		end
	end
end
function cm.distg(e,c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and aux.GetColumn(c,e:GetHandlerPlayer())==e:GetHandler():GetSequence()
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	local tseq=e:GetHandler():GetSequence()
	local loc,seq=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION,CHAININFO_TRIGGERING_SEQUENCE)
	if loc&LOCATION_SZONE~=0 and seq<=4 and re:IsActiveType(TYPE_SPELL+TYPE_TRAP)
		and ((rp==tp and seq==tseq) or (rp==1-tp and seq==4-tseq)) then
		Duel.NegateEffect(ev)
	end
end