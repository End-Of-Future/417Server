--M·A·L——Null
local m=30683425
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	--LINK PROD
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(1166)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(cm.linkcondition(cm.linkcheck,4,99,nil))
	e0:SetTarget(cm.linktarget(cm.linkcheck,4,99,gf))
	e0:SetOperation(cm.linkoperation(cm.linkcheck,4,99,nil))
	e0:SetValue(SUMMON_TYPE_LINK)
	c:RegisterEffect(e0)
	--effect gain
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(cm.regcon)
	e1:SetOperation(cm.regop)
	c:RegisterEffect(e1)
	--effect gain
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1)
	e2:SetCondition(cm.tkcon)
	e2:SetOperation(cm.tkop)
	c:RegisterEffect(e2)
end
function cm.linkcheck(c)
	return c:IsSetCard(0xc19) and c:IsLinkType(TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK)
end
function cm.check(sg,tp,lc,gf,lmat)
	return sg:GetCount()<=99 and sg:GetCount()>=1
		and Duel.GetLocationCountFromEx(tp,tp,sg,lc)>0 and (not gf or gf(sg))
		and not sg:IsExists(Auxiliary.LUncompatibilityFilter,1,nil,sg,lc,tp)
		and (not lmat or sg:IsContains(lmat))
end
function cm.linkcondition(f,minc,maxc,gf)
	return  function(e,c,og,lmat,min,max)
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
					mg=og:Filter(cm.ConditionFilter,nil,f,c,e)
				else
					mg=aux.GetLinkMaterials(tp,f,c,e)
				end
				if lmat~=nil then
					if not cm.ConditionFilter(lmat,f,c,e) then return false end
					mg:AddCard(lmat)
				end
				local fg=aux.GetMustMaterialGroup(tp,EFFECT_MUST_BE_LMATERIAL)
				if fg:IsExists(aux.MustMaterialCounterFilter,1,nil,mg) then return false end
				Duel.SetSelectedCard(fg)
				return mg:CheckSubGroup(cm.check,minc,maxc,tp,c,gf,lmat)
			end
end
function cm.linktarget(f,minc,maxc,gf)
	return  function(e,tp,eg,ep,ev,re,r,rp,chk,c,og,lmat,min,max)
				local minc=minc
				local maxc=maxc
				if min then
					if min>minc then minc=min end
					if max<maxc then maxc=max end
					if minc>maxc then return false end
				end
				local mg=nil
				if og then
					mg=og:Filter(cm.ConditionFilter,nil,f,c,e)
				else
					mg=aux.GetLinkMaterials(tp,f,c,e)
				end
				if lmat~=nil then
					if not cm.ConditionFilter(lmat,f,c,e) then return false end
					mg:AddCard(lmat)
				end
				local fg=aux.GetMustMaterialGroup(tp,EFFECT_MUST_BE_LMATERIAL)
				Duel.SetSelectedCard(fg)
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_LMATERIAL)
				local cancel=Duel.IsSummonCancelable()
				local sg=mg:SelectSubGroup(tp,cm.check,cancel,minc,maxc,tp,c,gf,lmat)
				if sg then
					sg:KeepAlive()
					e:SetLabelObject(sg)
					return true
				else return false end
			end
end
function cm.linkoperation(f,minc,maxc,gf)
	return  function(e,tp,eg,ep,ev,re,r,rp,c,og,lmat,min,max)
	local g=e:GetLabelObject()
	c:SetMaterial(g)
	local ec=g:GetFirst()
	local lm=0
	while ec do
		if ec:IsLinkMarker(LINK_MARKER_TOP_RIGHT) then lm=lm+0x100 end
		if ec:IsLinkMarker(LINK_MARKER_TOP_LEFT) then lm=lm+0x040 end
		if ec:IsLinkMarker(LINK_MARKER_TOP) then lm=lm+0x080 end
		if ec:IsLinkMarker(LINK_MARKER_LEFT) then lm=lm+0x008 end
		if ec:IsLinkMarker(LINK_MARKER_RIGHT) then lm=lm+0x020 end
		if ec:IsLinkMarker(LINK_MARKER_BOTTOM_LEFT) then lm=lm+0x001 end
		if ec:IsLinkMarker(LINK_MARKER_BOTTOM) then lm=lm+0x002 end
		if ec:IsLinkMarker(LINK_MARKER_BOTTOM_RIGHT) then lm=lm+0x004 end
		ec=g:GetNext()
			local e0=Effect.CreateEffect(c)
			e0:SetType(EFFECT_TYPE_SINGLE)
			e0:SetCode(EFFECT_ADD_LINK_MARKER_KOISHI)
			e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e0:SetValue(lm)
			e0:SetReset(RESET_EVENT+0x7e0000)
			c:RegisterEffect(e0)
			Auxiliary.LExtraMaterialCount(g,c,tp)
			Duel.SendtoGrave(g,REASON_MATERIAL+REASON_LINK)
			g:DeleteGroup()
		end
	end
end
function cm.regcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetMaterial():FilterCount(Card.IsLinkType,nil,TYPE_FUSION)>0 then
		--activate limit - fusion -> Search
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(m,0))
		e1:SetCategory(CATEGORY_SEARCH)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
		e1:SetProperty(EFFECT_FLAG_DELAY)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCountLimit(1)
		e1:SetCondition(cm.thcon1)
		e1:SetTarget(cm.thtac1)
		e1:SetOperation(cm.thop1)
		c:RegisterEffect(e1)
		c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,0))
	end
	if c:GetMaterial():FilterCount(Card.IsLinkType,nil,TYPE_SYNCHRO)>0 then
		--activate limit - synchro -> actlimit
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e2:SetCode(EFFECT_CANNOT_ACTIVATE)
		e2:SetRange(LOCATION_MZONE)
		e2:SetTargetRange(1,1)
		e2:SetValue(1)
		e2:SetCondition(cm.actcon2)
		c:RegisterEffect(e2)
		c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,1))
	end
	if c:GetMaterial():FilterCount(Card.IsLinkType,nil,TYPE_XYZ)>0 then
		--activate limit - XYZ -> spell
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
		e3:SetCode(EFFECT_TO_GRAVE_REDIRECT)
		e3:SetRange(LOCATION_MZONE)
		e3:SetTargetRange(0xff,0xff)
		e3:SetValue(LOCATION_DECK)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e3)
		c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,2))
	end
	if c:GetMaterial():FilterCount(Card.IsLinkType,nil,TYPE_LINK)>0 then
		--activate limit - Link -> must use Summon
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_FIELD)
		e4:SetCode(EFFECT_MUST_USE_MZONE)
		e4:SetRange(LOCATION_MZONE)
		e4:SetTargetRange(LOCATION_EXTRA,LOCATION_EXTRA)
		e4:SetValue(cm.frcval4)
		e4:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e4)
		c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,3))
	end
	Duel.Hint(24,0,aux.Stringid(m,12))
	Duel.Hint(24,0,aux.Stringid(m,13))
	Duel.Hint(24,0,aux.Stringid(m,14))
end
function cm.thfilter1(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function cm.thcon1(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer()
end
function cm.thtac1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter1,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
end
function cm.thop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter1,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SSet(tp,g:GetFirst())
	end
end
function cm.ffilter2(c)
	return c:IsFaceup() and c:IsType(TYPE_FIELD)
end
function cm.actcon2(e)
	local ph=Duel.GetCurrentPhase()
	local tp=e:GetHandlerPlayer()
	return Duel.IsExistingMatchingCard(cm.ffilter2,e:GetHandlerPlayer(),LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) and ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE
end
function cm.frcval4(e,c,fp,rp,r)
	local tp=e:GetHandlerPlayer()
	local zone = 0
	zone = zone | Duel.GetLinkedZone(tp)
	zone = zone | Duel.GetLinkedZone(1-tp)
	zone = zone | 0x60
	zone = zone | (0x60*0x10000)
	return zone
end
function cm.tkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function cm.tkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=c:GetMaterial()
	local link=0
	local tc=g:GetFirst()
	while tc do
		local lk
		if tc:IsLinkAbove(1) then 
			lk=tc:GetLink()
		else lk=0
		end
		link=link+lk
		tc=g:GetNext()
	end
	local atk=link*1000
	if c:GetFlagEffect(30683426)==0 and link>=1 then
		--atk
		local e1_1=Effect.CreateEffect(e:GetHandler())
		e1_1:SetType(EFFECT_TYPE_SINGLE)
		e1_1:SetCode(EFFECT_SET_BASE_ATTACK)
		e1_1:SetValue(atk)
		e1_1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1_1)
		c:RegisterFlagEffect(30683426,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,4))
	end
	if c:GetFlagEffect(30683427)==0 and link>=2 then
		--damage reduce
		local e2_1=Effect.CreateEffect(e:GetHandler())
		e2_1:SetType(EFFECT_TYPE_FIELD)
		e2_1:SetCode(EFFECT_CHANGE_DAMAGE)
		e2_1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e2_1:SetRange(LOCATION_MZONE)
		e2_1:SetTargetRange(1,0)
		e2_1:SetValue(cm.damval)
		e2_1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e2_1)
		local e3_1=e2_1:Clone()
		e3_1:SetCode(EFFECT_NO_EFFECT_DAMAGE)
		c:RegisterEffect(e3_1)
		c:RegisterFlagEffect(30683427,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,5))
	end
	if c:GetFlagEffect(30683428)==0 and link>=4 then
		--atlimit
		local e4_1=Effect.CreateEffect(e:GetHandler())
		e4_1:SetType(EFFECT_TYPE_FIELD)
		e4_1:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
		e4_1:SetRange(LOCATION_MZONE)
		e4_1:SetTargetRange(0,LOCATION_MZONE)
		e4_1:SetValue(cm.atlimit)
		e4_1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e4_1)
		c:RegisterFlagEffect(30683428,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,6))
	end
	if c:GetFlagEffect(30683429)==0 and link>=5 then
		--atkup
		local e5_1=Effect.CreateEffect(e:GetHandler())
		e5_1:SetType(EFFECT_TYPE_SINGLE)
		e5_1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e5_1:SetRange(LOCATION_MZONE)
		e5_1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e5_1:SetValue(cm.atkval)
		e5_1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e5_1)
		c:RegisterFlagEffect(30683429,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,7))
	end
	if c:GetFlagEffect(30683430)==0 and link>=7 then
		--Damage
		local e6_1=Effect.CreateEffect(e:GetHandler())
		e6_1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e6_1:SetCode(EVENT_PRE_BATTLE_DAMAGE)
		e6_1:SetRange(LOCATION_MZONE)
		e6_1:SetOperation(cm.rdop)
		e6_1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e6_1) 
		c:RegisterFlagEffect(30683430,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,8))
	end
	if c:GetFlagEffect(30683431)==0 and link>=8 then
		--pierce
		local e8_1=Effect.CreateEffect(e:GetHandler())
		e8_1:SetType(EFFECT_TYPE_SINGLE)
		e8_1:SetCode(EFFECT_PIERCE)
		e8_1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e8_1)
		c:RegisterFlagEffect(30683431,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,9))
	end
end
function cm.damval(e,re,val,r,rp,rc)
	if bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0 then return 0 end
	return val
end
function cm.atlimit(e,c)
	return c~=e:GetHandler()
end
function cm.atkval(e,c)
	return c:GetAttack()*2
end
function cm.rdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(ep,ev*3)
end

